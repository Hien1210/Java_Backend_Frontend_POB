/**
 * Popup thong bao (toast) dung chung cho toan he thong.
 * Tu doc query string success/error tren URL hien tai va hien popup goc tren-phai,
 * tu bien mat sau vai giay. Khong can sua HTML/CSS rieng cua tung trang.
 *
 * Dung thu cong: window.showToast('success'|'error', 'Noi dung...')
 */
(function () {
    var STYLE_ID = 'app-toast-style';
    var CONTAINER_ID = 'app-toast-container';

    function ensureStyle() {
        if (document.getElementById(STYLE_ID)) return;
        var style = document.createElement('style');
        style.id = STYLE_ID;
        style.textContent =
            '#' + CONTAINER_ID + '{position:fixed;top:20px;right:20px;z-index:99999;display:flex;flex-direction:column;gap:10px;max-width:360px;}' +
            '.app-toast{display:flex;align-items:flex-start;gap:10px;padding:14px 16px;border-radius:10px;' +
            'box-shadow:0 8px 24px rgba(0,0,0,0.18);font-family:inherit;font-size:14px;line-height:1.4;' +
            'color:#1a1a2e;background:#fff;border-left:5px solid #ccc;opacity:0;transform:translateX(30px);' +
            'transition:opacity .25s ease,transform .25s ease;}' +
            '.app-toast.show{opacity:1;transform:translateX(0);}' +
            '.app-toast.hide{opacity:0;transform:translateX(30px);}' +
            '.app-toast-success{border-left-color:#22c55e;}' +
            '.app-toast-error{border-left-color:#ef4444;}' +
            '.app-toast-info{border-left-color:#3b82f6;}' +
            '.app-toast-icon{font-size:18px;line-height:1;}' +
            '.app-toast-msg{flex:1;}' +
            '.app-toast-close{cursor:pointer;color:#999;font-size:16px;line-height:1;background:none;border:none;padding:0;}' +
            '.app-toast-close:hover{color:#333;}';
        document.head.appendChild(style);
    }

    function ensureContainer() {
        var el = document.getElementById(CONTAINER_ID);
        if (!el) {
            el = document.createElement('div');
            el.id = CONTAINER_ID;
            document.body.appendChild(el);
        }
        return el;
    }

    function iconFor(type) {
        if (type === 'success') return '✅';
        if (type === 'error') return '❌';
        return 'ℹ️';
    }

    window.showToast = function (type, message, durationMs) {
        if (!message) return;
        ensureStyle();
        var container = ensureContainer();
        var toast = document.createElement('div');
        toast.className = 'app-toast app-toast-' + (type || 'info');
        toast.innerHTML =
            '<span class="app-toast-icon">' + iconFor(type) + '</span>' +
            '<span class="app-toast-msg"></span>' +
            '<button type="button" class="app-toast-close">&times;</button>';
        toast.querySelector('.app-toast-msg').textContent = message;
        container.appendChild(toast);

        function remove() {
            toast.classList.add('hide');
            setTimeout(function () {
                if (toast.parentNode) toast.parentNode.removeChild(toast);
            }, 250);
        }

        toast.querySelector('.app-toast-close').addEventListener('click', remove);
        requestAnimationFrame(function () {
            toast.classList.add('show');
        });
        setTimeout(remove, durationMs || 4000);
    };

    // Bang dich cac ma thong bao pho bien (success/error) da dung rai rac trong du an
    // sang thong bao tieng Viet de tu dong hien popup khi trang load qua redirect.
    var SUCCESS_MESSAGES = {
        create: 'Thêm mới thành công!',
        created: 'Thêm mới thành công!',
        update: 'Cập nhật thành công!',
        updated: 'Cập nhật thành công!',
        delete: 'Xóa thành công!',
        deleted: 'Xóa thành công!',
        restore: 'Khôi phục thành công!',
        restored: 'Khôi phục thành công!',
        approved: 'Đã duyệt thành công!',
        rejected: 'Đã từ chối yêu cầu!',
        taken: 'Đã nhận đơn thành công!',
        password_changed: 'Đổi mật khẩu thành công! Vui lòng đăng nhập lại.',
        order_cancelled: 'Đã hủy đơn hàng thành công!',
        1: 'Thao tác thành công!'
    };
    var ERROR_MESSAGES = {
        missing: 'Thiếu thông tin bắt buộc!',
        offline: 'Không thể thực hiện, vui lòng thử lại!',
        not_found: 'Không tìm thấy đơn hàng!',
        cannot_cancel: 'Đơn hàng này hiện không thể hủy!',
        1: 'Đã xảy ra lỗi, vui lòng thử lại!'
    };

    function messageFromCode(map, code) {
        if (map.hasOwnProperty(code)) return map[code];
        // Neu servlet truyen thang chuoi mo ta (khong phai ma ngan), hien luon chuoi do
        if (code && code.length > 3) return decodeURIComponent(code.replace(/\+/g, ' '));
        return null;
    }

    function initFromQueryString() {
        var params = new URLSearchParams(window.location.search);
        var success = params.get('success');
        var error = params.get('error');
        if (success) {
            var msg = messageFromCode(SUCCESS_MESSAGES, success) || 'Thao tác thành công!';
            showToast('success', msg);
        }
        if (error) {
            var emsg = messageFromCode(ERROR_MESSAGES, error) || 'Đã xảy ra lỗi, vui lòng thử lại!';
            showToast('error', emsg);
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initFromQueryString);
    } else {
        initFromQueryString();
    }
})();
