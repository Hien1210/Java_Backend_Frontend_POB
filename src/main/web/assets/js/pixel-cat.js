/* Easter egg: An 5 lan vao badge/text "⚡ Super Admin" trong ho so Super Admin de mo bang Nhom Phat Trien */
(function () {
    var STYLE_ID = 'pixel-cat-style';

    var TEAM = [
        { name: 'Phạm Gia Hưng', code: 'TY00316', role: 'Trưởng nhóm', task: 'Thiết kế cấu trúc Cơ sở dữ liệu (Database), Lập trình Hệ thống (Backend)' },
        { name: 'Phùng Bảo Bảo', code: 'TY00366', role: 'Thành viên', task: 'Thiết kế cấu trúc Cơ sở dữ liệu (Database), Lập trình Hệ thống (Backend)' },
        { name: 'Phan Thanh Hiền', code: 'TY00243', role: 'Thành viên', task: 'Xây dựng luồng xử lý nghiệp vụ Core API (Backend)' },
        { name: 'Nguyễn Võ Hà Nam', code: 'TY00275', role: 'Thành viên', task: 'Nghiên cứu & Lập trình Giao diện tương tác hệ thống (Frontend)' },
        { name: 'Lại Tiến Dũng', code: 'TY00306', role: 'Thành viên', task: 'Nghiên cứu & Lập trình Giao diện tương tác hệ thống (Frontend)' },
        { name: 'Đỗ Gia Phúc', code: 'TY00253', role: 'Thành viên', task: 'Nghiên cứu & Lập trình Giao diện tương tác hệ thống (Frontend)' }
    ];

    if (!document.getElementById(STYLE_ID)) {
        var style = document.createElement('style');
        style.id = STYLE_ID;
        style.textContent = [
            '.pixel-cat-trigger, .pixel-cat-reveal, .pixel-cat-runway { display: none !important; opacity: 0 !important; pointer-events: none !important; }',
            '.badge-primary, .profile-username, .brand-title { cursor: pointer; user-select: none; }',

            /* modal thong tin nhom */
            '.pixel-cat-overlay{position:fixed;inset:0;z-index:9999;background:rgba(10,14,20,.65);',
            'display:flex;align-items:center;justify-content:center;padding:24px;',
            'animation:pixelCatFade .2s ease both;backdrop-filter:blur(3px);}',
            '@keyframes pixelCatFade{from{opacity:0;}to{opacity:1;}}',
            '.pixel-cat-modal{width:100%;max-width:900px;max-height:88vh;overflow:auto;border-radius:20px;',
            'background:var(--bg-panel,#fff);box-shadow:0 24px 60px rgba(0,0,0,.35);',
            'animation:pixelCatPop .28s cubic-bezier(.34,1.56,.64,1) both;}',
            '@keyframes pixelCatPop{from{opacity:0;transform:scale(.92) translateY(14px);}',
            'to{opacity:1;transform:scale(1) translateY(0);}}',
            '.pcm-header{position:relative;padding:28px 32px;border-radius:20px 20px 0 0;color:#fff;',
            'background:linear-gradient(135deg,#10b981 0%,#0ea5e9 55%,#6366f1 100%);}',
            '.pcm-header h2{margin:0;font-size:22px;font-weight:800;letter-spacing:.3px;}',
            '.pcm-header p{margin:6px 0 0;font-size:13px;opacity:.92;}',
            '.pcm-close{position:absolute;top:18px;right:18px;width:34px;height:34px;border-radius:50%;',
            'border:none;background:rgba(255,255,255,.18);color:#fff;font-size:18px;cursor:pointer;',
            'display:flex;align-items:center;justify-content:center;transition:background .15s ease;}',
            '.pcm-close:hover{background:rgba(255,255,255,.32);}',
            '.pcm-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:16px;padding:24px 28px 30px;}',
            '.pcm-card{border:1px solid var(--border-color,#e5e7eb);border-radius:14px;padding:18px;',
            'background:var(--bg-input,#f8fafc);display:flex;flex-direction:column;gap:10px;',
            'transition:transform .18s ease,box-shadow .18s ease;}',
            '.pcm-card:hover{transform:translateY(-4px);box-shadow:0 10px 22px rgba(0,0,0,.14);}',
            '.pcm-card.leader{border-color:#f59e0b;background:linear-gradient(180deg,rgba(245,158,11,.12),transparent 60%);}',
            '.pcm-top{display:flex;align-items:center;gap:12px;}',
            '.pcm-avatar{width:46px;height:46px;border-radius:50%;flex-shrink:0;display:flex;',
            'align-items:center;justify-content:center;font-weight:800;font-size:15px;color:#fff;',
            'background:linear-gradient(135deg,#10b981,#0ea5e9);}',
            '.pcm-card.leader .pcm-avatar{background:linear-gradient(135deg,#f59e0b,#f97316);}',
            '.pcm-name{font-size:15px;font-weight:800;color:var(--text-main,#0f172a);}',
            '.pcm-code{font-size:12px;color:var(--text-muted,#64748b);font-weight:600;margin-top:1px;}',
            '.pcm-badge{align-self:flex-start;font-size:11px;font-weight:700;padding:3px 10px;border-radius:999px;',
            'background:var(--primary-light,rgba(16,185,129,.15));color:var(--primary,#10b981);}',
            '.pcm-card.leader .pcm-badge{background:rgba(245,158,11,.18);color:#b45309;}',
            '.pcm-task-label{font-size:11px;font-weight:700;color:var(--text-dim,#94a3b8);text-transform:uppercase;',
            'letter-spacing:.4px;margin-top:2px;}',
            '.pcm-task{font-size:13px;color:var(--text-muted,#475569);line-height:1.5;}'
        ].join('');
        document.head.appendChild(style);
    }

    function buildTeamModal() {
        if (document.querySelector('.pixel-cat-overlay')) return;

        var overlay = document.createElement('div');
        overlay.className = 'pixel-cat-overlay';

        var cardsHtml = TEAM.map(function (m) {
            var initials = m.name.trim().split(/\s+/).slice(-2).map(function (w) { return w[0]; }).join('').toUpperCase();
            var leaderClass = m.role === 'Trưởng nhóm' ? ' leader' : '';
            return '' +
                '<div class="pcm-card' + leaderClass + '">' +
                    '<div class="pcm-top">' +
                        '<div class="pcm-avatar">' + initials + '</div>' +
                        '<div>' +
                            '<div class="pcm-name">' + m.name + '</div>' +
                            '<div class="pcm-code">MSSV: ' + m.code + '</div>' +
                        '</div>' +
                    '</div>' +
                    '<span class="pcm-badge">' + (m.role === 'Trưởng nhóm' ? '👑 ' : '👤 ') + m.role + '</span>' +
                    '<div>' +
                        '<div class="pcm-task-label">Công việc trong dự án</div>' +
                        '<div class="pcm-task">' + m.task + '</div>' +
                    '</div>' +
                '</div>';
        }).join('');

        overlay.innerHTML =
            '<div class="pixel-cat-modal" role="dialog" aria-modal="true">' +
                '<div class="pcm-header">' +
                    '<button type="button" class="pcm-close" aria-label="Đóng">✕</button>' +
                    '<h2>🚀 Nhóm phát triển dự án POB</h2>' +
                    '<p>Đội ngũ thực hiện đồ án — vai trò &amp; công việc phụ trách</p>' +
                '</div>' +
                '<div class="pcm-grid">' + cardsHtml + '</div>' +
            '</div>';

        function close() {
            overlay.remove();
            document.removeEventListener('keydown', onKey);
        }
        function onKey(e) { if (e.key === 'Escape') close(); }

        overlay.addEventListener('click', function (e) { if (e.target === overlay) close(); });
        overlay.querySelector('.pcm-close').addEventListener('click', close);
        document.addEventListener('keydown', onKey);

        document.body.appendChild(overlay);
    }

    // Activate modal by clicking 5 times on Super Admin badge / text
    var clickCount = 0;
    var clickTimer = null;

    document.addEventListener('click', function (e) {
        var el = e.target;
        if (!el) return;

        var txt = (el.textContent || '').trim().toUpperCase();
        var isSuperAdminBadge = false;

        if (txt.includes('SUPER ADMIN') || el.classList.contains('badge-primary') || el.closest('.badge-primary')) {
            isSuperAdminBadge = true;
        }

        if (isSuperAdminBadge) {
            clickCount++;
            clearTimeout(clickTimer);

            clickTimer = setTimeout(function () {
                clickCount = 0;
            }, 2000);

            if (clickCount >= 5) {
                clickCount = 0;
                clearTimeout(clickTimer);
                buildTeamModal();
            }
        }
    });

    // Clean up any legacy elements
    function cleanup() {
        document.querySelectorAll('.pixel-cat-trigger, .pixel-cat-reveal, .pixel-cat-runway').forEach(function (el) {
            el.remove();
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', cleanup);
    } else {
        cleanup();
    }
})();

