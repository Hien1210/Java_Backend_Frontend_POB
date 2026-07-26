/*
 * POB Food — logic dùng chung cho nút chuyển Sáng/Tối trên các trang dashboard
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
})();
