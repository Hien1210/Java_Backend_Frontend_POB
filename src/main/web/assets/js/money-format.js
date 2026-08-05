/**
 * money-format.js
 * Áp dụng format dấu chấm nghìn cho tất cả input có data-money="true".
 * Giá trị thật (không có dấu chấm) được gửi lên server khi submit form.
 *
 * Cách dùng:
 *   <input type="text" data-money="true" name="price" ...>
 *   <script src=".../money-format.js"></script>
 *   // Gọi lại initMoneyInputs() nếu thêm input động sau khi trang load
 */

(function () {
    function fmt(digits) {
        return digits.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
    }

    function rawValue(input) {
        return input.value.replace(/\./g, '').replace(/\D/g, '');
    }

    function applyFormat(input) {
        var digits = rawValue(input);
        var pos = input.selectionStart;
        var oldLen = input.value.length;
        input.value = digits ? fmt(digits) : '';
        // giữ vị trí con trỏ sau khi thêm/xóa dấu chấm
        var newLen = input.value.length;
        input.setSelectionRange(pos + (newLen - oldLen), pos + (newLen - oldLen));
    }

    // Tạo hoặc lấy lại phần tử thông báo lỗi gắn với input
    function getErrorEl(input) {
        var id = input.__moneyErrId;
        if (id) return document.getElementById(id);
        id = 'money-err-' + Math.random().toString(36).slice(2);
        input.__moneyErrId = id;
        var el = document.createElement('div');
        el.id = id;
        el.style.cssText = 'display:none;font-size:12px;color:#e53e3e;margin-top:3px;font-weight:600;';
        input.insertAdjacentElement('afterend', el);
        return el;
    }

    function showError(input, msg) {
        var el = getErrorEl(input);
        el.textContent = '⚠ ' + msg;
        el.style.display = 'block';
        input.style.borderColor = '#e53e3e';
        clearTimeout(input.__moneyErrTimer);
        input.__moneyErrTimer = setTimeout(function () { hideError(input); }, 3000);
    }

    function hideError(input) {
        var el = input.__moneyErrId ? document.getElementById(input.__moneyErrId) : null;
        if (el) el.style.display = 'none';
        input.style.borderColor = '';
    }

    function hookInput(input) {
        if (input.__moneyHooked) return;
        input.__moneyHooked = true;

        // chuyển type="number" → text để tránh browser validation xung đột
        input.type = 'text';
        input.setAttribute('inputmode', 'numeric');
        input.setAttribute('autocomplete', 'off');

        // format giá trị ban đầu (giá trị server có thể là số thập phân kiểu "5000.0")
        var initNum = parseFloat(input.value);
        var initDigits = isNaN(initNum) ? '' : String(Math.round(initNum));
        input.value = initDigits ? fmt(initDigits) : '';

        input.addEventListener('input', function () {
            applyFormat(input);
            hideError(input);
        });

        input.addEventListener('keydown', function (e) {
            if (
                /^\d$/.test(e.key) ||
                ['Backspace', 'Delete', 'Tab', 'ArrowLeft', 'ArrowRight', 'Home', 'End'].includes(e.key) ||
                e.ctrlKey || e.metaKey
            ) return;

            e.preventDefault();

            // thông báo riêng khi nhấn dấu trừ
            if (e.key === '-' || e.key === '_') {
                showError(input, 'Số tiền không được nhỏ hơn 0');
            }
        });

        // xử lý paste: lọc số âm / ký tự lạ rồi hiện cảnh báo nếu cần
        input.addEventListener('paste', function (e) {
            e.preventDefault();
            var text = (e.clipboardData || window.clipboardData).getData('text');
            var num = parseFloat(text.replace(/[^\d.-]/g, ''));
            if (!isNaN(num) && num < 0) {
                showError(input, 'Số tiền không được nhỏ hơn 0');
                return;
            }
            var digits = text.replace(/\D/g, '');
            if (digits) {
                input.value = fmt(digits);
                hideError(input);
            }
        });

        // trước khi submit: ghi lại số thật vào value (bỏ dấu chấm)
        var form = input.closest('form');
        if (form && !form.__moneySubmitHooked) {
            form.__moneySubmitHooked = true;
            form.addEventListener('submit', function () {
                form.querySelectorAll('input[data-money="true"]').forEach(function (el) {
                    el.value = el.value.replace(/\./g, '');
                });
            });
        }
    }

    /** Khởi tạo tất cả input[data-money="true"] hiện có trong DOM */
    function initMoneyInputs(root) {
        (root || document).querySelectorAll('input[data-money="true"]').forEach(hookInput);
    }

    // Tự chạy khi DOM sẵn sàng
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function () { initMoneyInputs(); });
    } else {
        initMoneyInputs();
    }

    // expose để các trang gọi lại sau khi thêm row động
    window.initMoneyInputs = initMoneyInputs;
})();
