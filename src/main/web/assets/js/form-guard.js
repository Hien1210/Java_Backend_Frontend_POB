// Chong bam-2-lan (double-submit) tren cac form quan trong (tien, don hang, trang thai...).
// Dung: <form onsubmit="return pobGuardSubmit(this)"> hoac ket hop voi confirm():
//       <form onsubmit="return confirm('...') && pobGuardSubmit(this)">
function pobGuardSubmit(form) {
    if (form.dataset.submitting === '1') {
        return false;
    }
    form.dataset.submitting = '1';

    // Nut submit nam TRONG form + nut submit nam NGOAI form nhung tro toi form nay qua
    // thuoc tinh form="<id>" (vd modal-actions cua _invoiceModal.jspf) - ca 2 truong hop
    // deu phai bi khoa, neu khong nut ngoai form van bam duoc lien tuc.
    var buttons = Array.prototype.slice.call(form.querySelectorAll('button[type="submit"], input[type="submit"]'));
    if (form.id) {
        var outside = document.querySelectorAll('button[form="' + form.id + '"], input[form="' + form.id + '"]');
        buttons = buttons.concat(Array.prototype.slice.call(outside));
    }

    buttons.forEach(function (btn) {
        btn.disabled = true;
        if (!btn.dataset.origText) {
            btn.dataset.origText = btn.tagName === 'INPUT' ? btn.value : btn.innerHTML;
        }
        var loadingText = btn.dataset.loadingText || 'Đang xử lý...';
        if (btn.tagName === 'INPUT') {
            btn.value = loadingText;
        } else {
            btn.innerHTML = loadingText;
        }
    });
    return true;
}
