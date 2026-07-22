/**
 * Ket noi WebSocket toi /ws/notifications de nhan thong bao realtime (khong can tai lai trang).
 * Yeu cau bien toan cuc window.POB_CONTEXT_PATH duoc set truoc khi include file nay, vd:
 *   <script>window.POB_CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
 *   <script src="${pageContext.request.contextPath}/assets/js/notifications-ws.js"></script>
 *
 * Khi co thong bao moi:
 *  - Hien toast (neu trang co include toast.js / window.showToast).
 *  - Cap nhat moi phan tu co attribute [data-notif-badge] bang so luong chua doc moi nhat.
 *  - Ban su kien DOM "pob-notification" (detail = {id, title, message, unreadCount}) de trang
 *    hien tai tu xu ly them neu can (vd trang /user/thong-bao tu load lai danh sach).
 */
(function () {
    if (!window.WebSocket) return;

    var ctx = window.POB_CONTEXT_PATH || '';
    var proto = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
    var url = proto + window.location.host + ctx + '/ws/notifications';

    function updateBadges(count) {
        document.querySelectorAll('[data-notif-badge]').forEach(function (el) {
            el.textContent = count;
            el.style.display = count > 0 ? '' : 'none';
        });
    }

    function connect() {
        var ws;
        try {
            ws = new WebSocket(url);
        } catch (e) {
            return;
        }

        ws.onmessage = function (evt) {
            var data;
            try {
                data = JSON.parse(evt.data);
            } catch (e) {
                return;
            }
            if (window.showToast) {
                window.showToast('info', (data.title || 'Thông báo mới') + (data.message ? ': ' + data.message : ''));
            }
            updateBadges(data.unreadCount || 0);
            document.dispatchEvent(new CustomEvent('pob-notification', {detail: data}));
        };

        ws.onclose = function () {
            // Mat ket noi (vd mang chap chon) -> thu lai sau 5s, khong bao loi ra console lien tuc.
            setTimeout(connect, 5000);
        };
        ws.onerror = function () {
            try { ws.close(); } catch (e) { /* ignore */ }
        };
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', connect);
    } else {
        connect();
    }
})();
