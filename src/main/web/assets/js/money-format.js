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

    function hookInput(input) {
        if (input.__moneyHooked) return;
        input.__moneyHooked = true;

        // chuyển type="number" → text để tránh browser validation xung đột
        input.type = 'text';
        input.setAttribute('inputmode', 'numeric');
        input.setAttribute('autocomplete', 'off');

        // format giá trị ban đầu
        var initDigits = input.value.replace(/\D/g, '');
        input.value = initDigits ? fmt(initDigits) : '';

        input.addEventListener('input', function () { applyFormat(input); });

        input.addEventListener('keydown', function (e) {
            if (
                /^\d$/.test(e.key) ||
                ['Backspace', 'Delete', 'Tab', 'ArrowLeft', 'ArrowRight', 'Home', 'End'].includes(e.key) ||
                e.ctrlKey || e.metaKey
            ) return;
            e.preventDefault();
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
