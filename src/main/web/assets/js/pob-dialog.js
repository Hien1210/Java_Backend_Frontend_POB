/**
 * POB Dialog — Popup xác nhận / thông báo / nhập liệu tùy chỉnh.
 * Thay thế confirm(), alert(), prompt() mặc định của trình duyệt bằng modal đẹp.
 *
 * API:
 *   pobConfirm(message)            → Promise<boolean>
 *   pobAlert(message)              → Promise<void>
 *   pobPrompt(message, defaultVal) → Promise<string|null>
 *
 * Tự động override window.confirm cho inline handlers (onclick, onsubmit)
 * và window.alert → dùng showToast nếu có, fallback sang modal.
 *
 * Yêu cầu: include SAU toast.js (nếu muốn alert fallback sang toast).
 */
(function () {
    'use strict';

    var STYLE_ID  = 'pob-dialog-style';
    var OVERLAY_CLASS = 'pob-dialog-overlay';

    /* ========== INJECT CSS ========== */
    function ensureStyle() {
        if (document.getElementById(STYLE_ID)) return;
        var s = document.createElement('style');
        s.id = STYLE_ID;
        s.textContent = [
            /* Overlay */
            '.' + OVERLAY_CLASS + '{',
            '  position:fixed;inset:0;z-index:100000;',
            '  display:flex;align-items:center;justify-content:center;',
            '  background:rgba(0,0,0,.45);',
            '  opacity:0;transition:opacity .2s ease;',
            '}',
            '.' + OVERLAY_CLASS + '.pob-show{opacity:1;}',
            '.' + OVERLAY_CLASS + '.pob-hide{opacity:0;}',

            /* Card */
            '.pob-dialog-card{',
            '  background:#fff;border-radius:16px;',
            '  box-shadow:0 20px 60px rgba(0,0,0,.22);',
            '  padding:28px 32px 22px;',
            '  min-width:340px;max-width:460px;width:90%;',
            '  transform:scale(.92) translateY(10px);',
            '  transition:transform .25s cubic-bezier(.34,1.56,.64,1),opacity .2s ease;',
            '  opacity:0;',
            '  font-family:"Segoe UI",system-ui,-apple-system,Tahoma,Geneva,Verdana,sans-serif;',
            '}',
            '.' + OVERLAY_CLASS + '.pob-show .pob-dialog-card{',
            '  transform:scale(1) translateY(0);opacity:1;',
            '}',
            '.' + OVERLAY_CLASS + '.pob-hide .pob-dialog-card{',
            '  transform:scale(.92) translateY(10px);opacity:0;',
            '}',

            /* Icon */
            '.pob-dialog-icon{',
            '  width:52px;height:52px;border-radius:50%;',
            '  display:flex;align-items:center;justify-content:center;',
            '  font-size:24px;margin:0 auto 14px;',
            '}',
            '.pob-dialog-icon.pob-icon-confirm{background:rgba(255,87,34,.12);color:#FF5722;}',
            '.pob-dialog-icon.pob-icon-alert{background:rgba(59,130,246,.12);color:#3b82f6;}',
            '.pob-dialog-icon.pob-icon-prompt{background:rgba(34,197,94,.12);color:#22c55e;}',
            '.pob-dialog-icon.pob-icon-warning{background:rgba(245,158,11,.12);color:#f59e0b;}',

            /* Title */
            '.pob-dialog-title{',
            '  font-size:17px;font-weight:700;color:#1a1a2e;',
            '  text-align:center;margin-bottom:8px;line-height:1.35;',
            '}',

            /* Message */
            '.pob-dialog-msg{',
            '  font-size:14.5px;color:#555;text-align:center;',
            '  line-height:1.55;margin-bottom:22px;white-space:pre-line;word-break:break-word;',
            '}',

            /* Input (prompt) */
            '.pob-dialog-input{',
            '  width:100%;padding:10px 14px;font-size:14px;',
            '  border:1.5px solid #e0e0e0;border-radius:8px;',
            '  outline:none;transition:border-color .15s;',
            '  margin-bottom:18px;font-family:inherit;',
            '}',
            '.pob-dialog-input:focus{border-color:#FF5722;box-shadow:0 0 0 3px rgba(255,87,34,.12);}',

            /* Buttons row */
            '.pob-dialog-btns{',
            '  display:flex;gap:10px;justify-content:center;',
            '}',
            '.pob-dialog-btns button{',
            '  padding:10px 28px;border-radius:8px;font-size:14px;',
            '  font-weight:600;cursor:pointer;border:none;',
            '  transition:background .15s,transform .1s,box-shadow .15s;',
            '  font-family:inherit;line-height:1.2;',
            '}',
            '.pob-dialog-btns button:active{transform:scale(.96);}',

            /* Cancel button */
            '.pob-btn-cancel{',
            '  background:#f0f0f0;color:#555;',
            '}',
            '.pob-btn-cancel:hover{background:#e4e4e4;color:#333;}',

            /* OK / Confirm button */
            '.pob-btn-ok{',
            '  background:#FF5722;color:#fff;',
            '  box-shadow:0 3px 10px rgba(255,87,34,.32);',
            '}',
            '.pob-btn-ok:hover{background:#E64A19;}',

            /* Danger variant */
            '.pob-btn-danger{',
            '  background:#ef4444;color:#fff;',
            '  box-shadow:0 3px 10px rgba(239,68,68,.28);',
            '}',
            '.pob-btn-danger:hover{background:#dc2626;}'
        ].join('\n');
        document.head.appendChild(s);
    }

    /* ========== CORE: create & show dialog ========== */
    /**
     * @param {Object} opts
     * @param {'confirm'|'alert'|'prompt'} opts.type
     * @param {string} opts.message
     * @param {string} [opts.title]
     * @param {string} [opts.defaultValue]  – prompt only
     * @param {string} [opts.okText]
     * @param {string} [opts.cancelText]
     * @param {boolean} [opts.danger]
     * @returns {Promise<boolean|string|null|void>}
     */
    function showDialog(opts) {
        ensureStyle();

        return new Promise(function (resolve) {
            var type = opts.type || 'alert';
            var overlay = document.createElement('div');
            overlay.className = OVERLAY_CLASS;

            /* Determine icon */
            var iconClass = 'pob-icon-confirm';
            var iconHtml  = '❓';
            if (type === 'alert') {
                iconClass = 'pob-icon-alert';
                iconHtml  = 'ℹ️';
            } else if (type === 'prompt') {
                iconClass = 'pob-icon-prompt';
                iconHtml  = '✏️';
            }
            /* Detect danger/delete messages */
            var msg = opts.message || '';
            var isDanger = opts.danger ||
                /xóa|xoá|delete|hủy|từ chối|bom/i.test(msg);
            if (isDanger && type === 'confirm') {
                iconClass = 'pob-icon-warning';
                iconHtml  = '⚠️';
            }

            /* Default title based on type */
            var title = opts.title;
            if (!title) {
                if (type === 'confirm') title = 'Xác nhận';
                else if (type === 'prompt') title = 'Nhập thông tin';
                else title = 'Thông báo';
            }

            /* Build card HTML */
            var html = '<div class="pob-dialog-card">';
            html += '<div class="pob-dialog-icon ' + iconClass + '">' + iconHtml + '</div>';
            html += '<div class="pob-dialog-title">' + escapeHtml(title) + '</div>';
            html += '<div class="pob-dialog-msg">' + escapeHtml(msg) + '</div>';

            if (type === 'prompt') {
                html += '<input class="pob-dialog-input" type="text" value="' +
                    escapeAttr(opts.defaultValue || '') + '" />';
            }

            html += '<div class="pob-dialog-btns">';
            if (type !== 'alert') {
                html += '<button type="button" class="pob-btn-cancel">' +
                    escapeHtml(opts.cancelText || 'Hủy') + '</button>';
            }
            var okBtnClass = isDanger ? 'pob-btn-danger' : 'pob-btn-ok';
            html += '<button type="button" class="' + okBtnClass + '">' +
                escapeHtml(opts.okText || (type === 'alert' ? 'Đã hiểu' : 'Xác nhận')) + '</button>';
            html += '</div></div>';

            overlay.innerHTML = html;
            document.body.appendChild(overlay);

            var card      = overlay.querySelector('.pob-dialog-card');
            var btnOk     = overlay.querySelector('.pob-btn-ok, .pob-btn-danger');
            var btnCancel = overlay.querySelector('.pob-btn-cancel');
            var inputEl   = overlay.querySelector('.pob-dialog-input');

            /* Animate in */
            requestAnimationFrame(function () {
                overlay.classList.add('pob-show');
            });

            /* Focus */
            setTimeout(function () {
                if (inputEl) { inputEl.focus(); inputEl.select(); }
                else if (btnOk) btnOk.focus();
            }, 80);

            function close(value) {
                overlay.classList.remove('pob-show');
                overlay.classList.add('pob-hide');
                setTimeout(function () {
                    if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
                }, 220);
                resolve(value);
            }

            btnOk.addEventListener('click', function () {
                if (type === 'confirm') close(true);
                else if (type === 'prompt') close(inputEl ? inputEl.value : '');
                else close(undefined);
            });

            if (btnCancel) {
                btnCancel.addEventListener('click', function () {
                    if (type === 'confirm') close(false);
                    else if (type === 'prompt') close(null);
                    else close(undefined);
                });
            }

            /* Close on overlay click (outside card) */
            overlay.addEventListener('click', function (e) {
                if (e.target === overlay) {
                    if (type === 'confirm') close(false);
                    else if (type === 'prompt') close(null);
                    else close(undefined);
                }
            });

            /* Enter / Escape keys */
            overlay.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') {
                    e.preventDefault();
                    if (type === 'confirm') close(false);
                    else if (type === 'prompt') close(null);
                    else close(undefined);
                }
                if (e.key === 'Enter') {
                    e.preventDefault();
                    if (type === 'confirm') close(true);
                    else if (type === 'prompt') close(inputEl ? inputEl.value : '');
                    else close(undefined);
                }
            });
        });
    }

    /* ========== ESCAPE HELPERS ========== */
    function escapeHtml(str) {
        var d = document.createElement('div');
        d.appendChild(document.createTextNode(str));
        return d.innerHTML;
    }
    function escapeAttr(str) {
        return str.replace(/&/g, '&amp;').replace(/"/g, '&quot;')
                  .replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    /* ========== PUBLIC API ========== */
    window.pobConfirm = function (message, opts) {
        opts = opts || {};
        opts.type = 'confirm';
        opts.message = message;
        return showDialog(opts);
    };

    window.pobAlert = function (message, opts) {
        opts = opts || {};
        opts.type = 'alert';
        opts.message = message;
        return showDialog(opts);
    };

    window.pobPrompt = function (message, defaultValue, opts) {
        opts = opts || {};
        opts.type = 'prompt';
        opts.message = message;
        opts.defaultValue = defaultValue || '';
        return showDialog(opts);
    };

    /* ========== OVERRIDE window.alert ========== */
    var _nativeAlert = window.alert;
    window.alert = function (msg) {
        /* Prefer showToast if available (from toast.js) */
        if (typeof window.showToast === 'function') {
            window.showToast('info', msg);
            return;
        }
        /* Fallback to modal */
        showDialog({ type: 'alert', message: String(msg) });
    };

    /* ========== INTERCEPT inline confirm() in onclick/onsubmit ========== */
    /*
     * Strategy: override window.confirm so that inline handlers like
     *   onclick="return confirm('...')"
     *   onsubmit="return confirm('...') && pobGuardSubmit(this)"
     * are intercepted. Since confirm() is synchronous and we can't block,
     * we:
     *   1. Return false immediately (cancel the action)
     *   2. Show the popup asynchronously
     *   3. If user clicks OK → replay the event (with a flag to skip re-prompting)
     */
    var _nativeConfirm = window.confirm;
    var _pobBypass = false;  // flag to let replayed events through

    window.confirm = function (msg) {
        // If bypass is active, this is a replayed event — let it through
        if (_pobBypass) return true;

        // Find the current event being handled
        var evt = window.event;
        if (!evt || !evt.target) {
            // Not called from an inline handler — can't intercept, use native
            // (This shouldn't happen in our codebase, but just in case)
            return _nativeConfirm.call(window, msg);
        }

        var target = evt.target;
        var eventType = evt.type;  // 'click' or 'submit'

        // Cancel the current event
        evt.preventDefault();
        if (evt.stopImmediatePropagation) evt.stopImmediatePropagation();

        // Show popup asynchronously
        showDialog({ type: 'confirm', message: String(msg) }).then(function (ok) {
            if (!ok) return;

            _pobBypass = true;

            if (eventType === 'submit') {
                // Re-submit the form
                var form = target.closest ? target.closest('form') : target;
                if (form && form.tagName === 'FORM') {
                    // Trigger the onsubmit handler again (which will call confirm again, but _pobBypass=true)
                    var submitEvt = new Event('submit', { bubbles: true, cancelable: true });
                    var allowed = form.dispatchEvent(submitEvt);
                    if (allowed) {
                        // Check if there's a submit button that was clicked
                        var submitBtn = form.querySelector('button[type="submit"], input[type="submit"]');
                        if (submitBtn && submitBtn.click) {
                            submitBtn.click();
                        } else {
                            form.submit();
                        }
                    }
                }
            } else if (eventType === 'click') {
                // Re-click the element
                if (target.click) {
                    target.click();
                } else if (target.closest('a')) {
                    var link = target.closest('a');
                    if (link.href) window.location.href = link.href;
                }
            }

            _pobBypass = false;
        });

        return false;  // Cancel the current event
    };

    /* ========== OVERRIDE window.prompt ========== */
    // prompt() is also synchronous. For inline usage it's less common,
    // but we'll handle it similarly for the few places that use it.
    // Since prompt needs async, inline usages MUST be refactored to use pobPrompt().
    // This override simply falls back to native for now.
    // Individual files that use prompt() in JS blocks will be refactored manually.

})();
