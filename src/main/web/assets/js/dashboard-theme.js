/*
 * FOOD MANAGE — logic dùng chung cho nút chuyển Sáng/Tối trên các trang dashboard
 * (Super Admin, Shipper). Trang nào không có nút .theme-toggle thì file này
 * chỉ set data-theme="light" mặc định, không ảnh hưởng gì.
 *
 * Lưu ý: đoạn set data-theme ban đầu (chống nháy màu) vẫn phải nằm inline
 * trong <head> của từng JSP vì phải chạy TRƯỚC khi CSS tải xong — file này
 * chỉ lo phần tương tác (bấm nút đổi theme, đổi icon).
 */
(function () {
    var STORAGE_KEY = 'pob-dashboard-theme';

    function applyIcon(theme) {
        document.querySelectorAll('[data-theme-icon]').forEach(function (el) {
            el.textContent = theme === 'dark' ? '☀️' : '🌙';
        });
    }

    window.pobToggleTheme = function () {
        var current = document.documentElement.getAttribute('data-theme') || 'light';
        var next = current === 'dark' ? 'light' : 'dark';
        document.documentElement.setAttribute('data-theme', next);
        try { localStorage.setItem(STORAGE_KEY, next); } catch (e) {}
        applyIcon(next);
    };

    var COLLAPSE_KEY = 'pob-sidebar-collapsed';

    function applyCollapseTooltips(sidebar, collapsed) {
        sidebar.querySelectorAll('.menu-item').forEach(function (item) {
            if (collapsed) {
                if (!item.getAttribute('data-label')) {
                    var label = item.querySelector('.mi-label');
                    item.setAttribute('data-label', label ? label.textContent.trim() : '');
                }
                item.setAttribute('title', item.getAttribute('data-label'));
            } else {
                item.removeAttribute('title');
            }
        });
    }

    window.pobToggleSidebar = function () {
        var sidebar = document.querySelector('.sidebar');
        if (!sidebar) return;

        // Desktop: thu gọn sidebar (chỉ icon) để nội dung chính rộng hơn.
        // Mobile: giữ hành vi cũ — hiện/ẩn dạng overlay.
        if (window.innerWidth >= 901) {
            var collapsed = sidebar.classList.toggle('collapsed');
            applyCollapseTooltips(sidebar, collapsed);
            try { localStorage.setItem(COLLAPSE_KEY, collapsed ? '1' : '0'); } catch (e) {}
        } else {
            var backdrop = document.querySelector('.sidebar-backdrop');
            sidebar.classList.toggle('open');
            if (backdrop) backdrop.classList.toggle('open');
        }
    };

    // Dropdown thu gon/mo rong tung nhom menu trong sidebar (bam vao tieu de nhom, VD "Topping").
    // Khong luu trang thai qua localStorage (moi trang tai lai la mo het, giong hanh vi cu truoc
    // khi co tinh nang nay) — tranh phai dong bo 1 bo ID nhom giua ~20 trang admin co ten nhom
    // khong hoan toan giong nhau.
    window.pobToggleMenuGroup = function (titleEl) {
        var group = titleEl.closest('.menu-group');
        if (group) group.classList.toggle('collapsed');
    };

    document.addEventListener('DOMContentLoaded', function () {
        applyIcon(document.documentElement.getAttribute('data-theme') || 'light');

        var backdrop = document.querySelector('.sidebar-backdrop');
        if (backdrop) backdrop.addEventListener('click', window.pobToggleSidebar);

        var sidebar = document.querySelector('.sidebar');
        if (sidebar && window.innerWidth >= 901) {
            var wasCollapsed = false;
            try { wasCollapsed = localStorage.getItem(COLLAPSE_KEY) === '1'; } catch (e) {}
            if (wasCollapsed) {
            sidebar.classList.add('collapsed');
            applyCollapseTooltips(sidebar, true);
        }
    }
});

/* ==== GLOBAL CUSTOM CONFIRM POPUP MODAL ==== */
window.pobConfirm = function (options) {
    if (typeof options === 'string') {
        options = { message: options };
    }
    options = options || {};
    var title = options.title || 'Xác nhận';
    var message = options.message || 'Bạn có chắc chắn muốn thực hiện thao tác này không?';
    var icon = options.icon || '⚠️';
    var confirmText = options.confirmText || 'Xác nhận';
    var cancelText = options.cancelText || 'Hủy';
    var confirmBtnClass = options.confirmClass || 'btn-danger';

    return new Promise(function (resolve) {
        var modal = document.getElementById('pobGlobalConfirmModal');
        if (!modal) {
            modal = document.createElement('div');
            modal.id = 'pobGlobalConfirmModal';
            modal.className = 'pob-modal-overlay';
            modal.style.zIndex = '9999';
            modal.innerHTML =
                '<div class="pob-modal-box" style="max-width: 420px; border-radius: 20px; padding: 28px; text-align: center;">' +
                    '<div id="pobGcIcon" style="width: 60px; height: 60px; margin: 0 auto 16px; background: rgba(239, 68, 68, 0.12); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 28px;">' + icon + '</div>' +
                    '<h3 id="pobGcTitle" style="margin: 0 0 10px; font-size: 18px; font-weight: 700; color: var(--text-main, #1e293b);">' + title + '</h3>' +
                    '<p id="pobGcMessage" style="margin: 0 0 24px; font-size: 13.5px; color: var(--text-muted, #64748b); line-height: 1.55;">' + message + '</p>' +
                    '<div style="display: flex; gap: 12px; justify-content: center;">' +
                        '<button type="button" id="pobGcCancelBtn" class="btn" style="flex: 1; padding: 10px 16px; border-radius: 12px; background: var(--bg-input, #f1f5f9); color: var(--text-main, #334155); border: 1px solid var(--border-color, #cbd5e1); font-weight: 600; cursor: pointer;">' + cancelText + '</button>' +
                        '<button type="button" id="pobGcConfirmBtn" class="btn ' + confirmBtnClass + '" style="flex: 1; padding: 10px 16px; border-radius: 12px; font-weight: 600; cursor: pointer;">' + confirmText + '</button>' +
                    '</div>' +
                '</div>';
            document.body.appendChild(modal);
        } else {
            document.getElementById('pobGcIcon').textContent = icon;
            document.getElementById('pobGcTitle').textContent = title;
            document.getElementById('pobGcMessage').innerHTML = message;
            var confirmBtn = document.getElementById('pobGcConfirmBtn');
            confirmBtn.textContent = confirmText;
            confirmBtn.className = 'btn ' + confirmBtnClass;
            document.getElementById('pobGcCancelBtn').textContent = cancelText;
        }

        var iconBg = 'rgba(239, 68, 68, 0.12)';
        if (confirmBtnClass.indexOf('primary') !== -1) iconBg = 'rgba(255, 87, 34, 0.12)';
        else if (confirmBtnClass.indexOf('warning') !== -1) iconBg = 'rgba(245, 158, 11, 0.14)';
        document.getElementById('pobGcIcon').style.background = iconBg;

        function cleanup() {
            modal.classList.remove('open');
            document.getElementById('pobGcConfirmBtn').removeEventListener('click', onOk);
            document.getElementById('pobGcCancelBtn').removeEventListener('click', onCancel);
            modal.removeEventListener('click', onBgClick);
            document.removeEventListener('keydown', onKeyEsc);
        }

        function onOk() {
            cleanup();
            resolve(true);
        }

        function onCancel() {
            cleanup();
            resolve(false);
        }

        function onBgClick(e) {
            if (e.target === modal) onCancel();
        }

        function onKeyEsc(e) {
            if (e.key === 'Escape') onCancel();
        }

        document.getElementById('pobGcConfirmBtn').addEventListener('click', onOk);
        document.getElementById('pobGcCancelBtn').addEventListener('click', onCancel);
        modal.addEventListener('click', onBgClick);
        document.addEventListener('keydown', onKeyEsc);

        setTimeout(function () {
            modal.classList.add('open');
        }, 10);
    });
};

window.pobConfirmDelete = function (event, formOrUrl, message, title) {
    if (event && event.preventDefault) event.preventDefault();

    pobConfirm({
        title: title || 'Xác nhận xóa',
        message: message || 'Bạn có chắc chắn muốn xóa không? Hành động này không thể hoàn tác.',
        icon: '🗑️',
        confirmText: 'Xóa ngay',
        cancelText: 'Hủy',
        confirmClass: 'btn-danger'
    }).then(function (confirmed) {
        if (confirmed) {
            if (typeof formOrUrl === 'string') {
                window.location.href = formOrUrl;
            } else if (formOrUrl && formOrUrl.tagName === 'FORM') {
                if (typeof pobGuardSubmit === 'function') {
                    pobGuardSubmit(formOrUrl);
                }
                formOrUrl.submit();
            }
        }
    });
    return false;
};
})();
