<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Địa chỉ giao hàng - POB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme-space.css">
    <style>
        .mini-nav { background: var(--bg-panel-solid); border-bottom: 1px solid var(--border-color); padding: 16px 24px; display: flex; align-items: center; gap: 16px; }
        .mini-nav .logo { width: 36px; height: 36px; border-radius: var(--radius-sm); background: linear-gradient(135deg, var(--primary), var(--secondary)); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; box-shadow: var(--glow-primary); }
        .mini-nav .title { font-size: 17px; font-weight: 800; color: var(--text-main); }
        .mini-nav .nav-links { margin-left: auto; display: flex; align-items: center; gap: 16px; }
        .mini-nav .nav-links a { font-size: 13px; color: var(--text-muted); }
        .mini-nav .nav-links a:hover { color: var(--secondary); }

        .container { max-width: 680px; margin: 0 auto; padding: 32px 16px; }
        .page-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
        .page-head h2 { font-size: 21px; font-weight: 800; color: var(--text-main); }

        .addr-list { display: flex; flex-direction: column; gap: 16px; }
        .addr-card { padding: 20px; position: relative; }
        .addr-card.is-default { border-color: var(--secondary); }
        .addr-default-badge { position: absolute; top: 16px; right: 16px; background: var(--info-light); color: var(--info); font-size: 11px; font-weight: 700; padding: 4px 12px; border-radius: var(--radius-pill); }
        .addr-label { font-size: 15px; font-weight: 800; color: var(--text-main); margin-bottom: 8px; }
        .addr-line { font-size: 13.5px; color: var(--text-muted); margin-bottom: 4px; }
        .addr-actions { display: flex; gap: 8px; margin-top: 14px; flex-wrap: wrap; }
        .addr-actions .btn { font-size: 12px; padding: 6px 12px; }

        /* Modal (dùng chung .pob-modal-*) */
        .pob-modal-box { padding: 24px; max-width: 420px; }
        .pob-modal-box .m-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 18px; }
        .pob-modal-box .m-head h3 { font-size: 16px; font-weight: 800; color: var(--text-main); }
        .pob-modal-box .m-close { background: none; border: none; color: var(--text-dim); font-size: 20px; cursor: pointer; }
        .fb-anon { display: flex; align-items: center; gap: 8px; font-size: 13px; color: var(--text-muted); cursor: pointer; user-select: none; }
        .fb-anon input { width: 16px; height: 16px; accent-color: var(--primary); }
    </style>
</head>
<body class="space-scope">
<div class="starfield"></div>

<div class="mini-nav">
    <div class="logo">POB</div>
    <span class="title">Địa chỉ giao hàng</span>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/user/donhang">📦 Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/user/thong-bao">🔔 Thông báo</a>
        <a href="${pageContext.request.contextPath}/">← Trang chủ</a>
    </div>
</div>

<div class="container">

    <c:if test="${param.success eq 'created'}">
        <div class="alert alert-success" style="margin-bottom:20px;">✅ Đã thêm địa chỉ mới thành công!</div>
    </c:if>
    <c:if test="${param.success eq 'updated'}">
        <div class="alert alert-success" style="margin-bottom:20px;">✅ Đã cập nhật địa chỉ thành công!</div>
    </c:if>
    <c:if test="${param.success eq 'deleted'}">
        <div class="alert alert-danger" style="margin-bottom:20px;">🗑️ Đã xóa địa chỉ.</div>
    </c:if>
    <c:if test="${param.success eq 'default'}">
        <div class="alert alert-info" style="margin-bottom:20px;">⭐ Đã đặt làm địa chỉ mặc định!</div>
    </c:if>
    <c:if test="${param.error eq 'missing'}">
        <div class="alert alert-danger" style="margin-bottom:20px;">❌ Vui lòng điền đầy đủ thông tin bắt buộc.</div>
    </c:if>

    <div class="page-head">
        <h2>Địa chỉ của tôi</h2>
        <button onclick="openModal('modalCreate')" class="btn btn-primary btn-sm">+ Thêm địa chỉ mới</button>
    </div>

    <c:choose>
        <c:when test="${empty addresses}">
            <div class="card empty-state">
                <div class="e-icon">📍</div>
                <div class="e-title">Bạn chưa có địa chỉ nào</div>
                <div class="e-sub">Thêm địa chỉ để đặt hàng nhanh hơn.</div>
                <button onclick="openModal('modalCreate')" class="btn btn-primary btn-sm" style="margin-top:16px;">+ Thêm địa chỉ mới</button>
            </div>
        </c:when>
        <c:otherwise>
            <div class="addr-list">
                <c:forEach var="addr" items="${addresses}">
                    <div class="card addr-card ${addr.isDefault ? 'is-default' : ''}">

                        <c:if test="${addr.isDefault}">
                            <span class="addr-default-badge">⭐ Mặc định</span>
                        </c:if>

                        <div class="addr-label">
                            <c:choose>
                                <c:when test="${addr.label eq 'Nhà'}">🏠</c:when>
                                <c:when test="${addr.label eq 'Công ty'}">🏢</c:when>
                                <c:when test="${addr.label eq 'Trường học'}">🎓</c:when>
                                <c:otherwise>📍</c:otherwise>
                            </c:choose>
                            ${addr.label}
                        </div>

                        <p class="addr-line">📍 ${addr.fullAddress}</p>
                        <p class="addr-line">👤 ${addr.receiverName} &nbsp;|&nbsp; 📞 ${addr.receiverPhone}</p>

                        <div class="addr-actions">
                            <c:if test="${!addr.isDefault}">
                                <form action="${pageContext.request.contextPath}/user/dia-chi" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="setDefault">
                                    <input type="hidden" name="id" value="${addr.id}">
                                    <button type="submit" class="btn btn-outline">⭐ Đặt mặc định</button>
                                </form>
                            </c:if>

                            <button onclick="openEdit(${addr.id}, '${addr.label}', '${addr.fullAddress}', '${addr.receiverName}', '${addr.receiverPhone}')" class="btn btn-ghost">✏️ Sửa</button>

                            <c:if test="${!addr.isDefault}">
                                <form action="${pageContext.request.contextPath}/user/dia-chi" method="post" style="display:inline;"
                                      onsubmit="return confirm('Xác nhận xóa địa chỉ này?')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${addr.id}">
                                    <button type="submit" class="btn btn-danger-outline">🗑️ Xóa</button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%-- ============ MODAL THÊM ============ --%>
<div id="modalCreate" class="pob-modal-overlay">
    <div class="pob-modal-box">
        <div class="m-head">
            <h3>➕ Thêm địa chỉ mới</h3>
            <button onclick="closeModal('modalCreate')" class="m-close">✕</button>
        </div>
        <form action="${pageContext.request.contextPath}/user/dia-chi" method="post">
            <input type="hidden" name="action" value="create">

            <div class="form-group">
                <label class="form-label">Nhãn địa chỉ</label>
                <select name="label" class="form-select">
                    <option value="Nhà">🏠 Nhà</option>
                    <option value="Công ty">🏢 Công ty</option>
                    <option value="Trường học">🎓 Trường học</option>
                    <option value="Khác">📍 Khác</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Địa chỉ đầy đủ <span class="required">*</span></label>
                <textarea class="form-textarea" name="fullAddress" rows="2" required placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố"></textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Tên người nhận <span class="required">*</span></label>
                    <input type="text" class="form-control" name="receiverName" required placeholder="Họ và tên">
                </div>
                <div class="form-group">
                    <label class="form-label">Số điện thoại <span class="required">*</span></label>
                    <input type="tel" class="form-control" name="receiverPhone" required placeholder="0xxxxxxxxx">
                </div>
            </div>

            <label class="fb-anon" style="margin-bottom:16px;">
                <input type="checkbox" name="isDefault" value="true">
                Đặt làm địa chỉ mặc định
            </label>

            <div style="display:flex;gap:12px;">
                <button type="button" onclick="closeModal('modalCreate')" class="btn btn-ghost" style="flex:1;">Hủy</button>
                <button type="submit" class="btn btn-primary" style="flex:1;">Lưu địa chỉ</button>
            </div>
        </form>
    </div>
</div>

<%-- ============ MODAL SỬA ============ --%>
<div id="modalEdit" class="pob-modal-overlay">
    <div class="pob-modal-box">
        <div class="m-head">
            <h3>✏️ Chỉnh sửa địa chỉ</h3>
            <button onclick="closeModal('modalEdit')" class="m-close">✕</button>
        </div>
        <form action="${pageContext.request.contextPath}/user/dia-chi" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" id="editId">

            <div class="form-group">
                <label class="form-label">Nhãn địa chỉ</label>
                <select name="label" id="editLabel" class="form-select">
                    <option value="Nhà">🏠 Nhà</option>
                    <option value="Công ty">🏢 Công ty</option>
                    <option value="Trường học">🎓 Trường học</option>
                    <option value="Khác">📍 Khác</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Địa chỉ đầy đủ <span class="required">*</span></label>
                <textarea class="form-textarea" name="fullAddress" id="editFullAddress" rows="2" required></textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Tên người nhận <span class="required">*</span></label>
                    <input type="text" class="form-control" name="receiverName" id="editReceiverName" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Số điện thoại <span class="required">*</span></label>
                    <input type="tel" class="form-control" name="receiverPhone" id="editReceiverPhone" required>
                </div>
            </div>

            <div style="display:flex;gap:12px;">
                <button type="button" onclick="closeModal('modalEdit')" class="btn btn-ghost" style="flex:1;">Hủy</button>
                <button type="submit" class="btn btn-primary" style="flex:1;">Cập nhật</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal(id) { document.getElementById(id).classList.add('open'); }
    function closeModal(id) { document.getElementById(id).classList.remove('open'); }

    ['modalCreate','modalEdit'].forEach(function (id) {
        document.getElementById(id).addEventListener('click', function (e) {
            if (e.target === this) closeModal(id);
        });
    });

    function openEdit(id, label, fullAddress, receiverName, receiverPhone) {
        document.getElementById('editId').value            = id;
        document.getElementById('editFullAddress').value   = fullAddress;
        document.getElementById('editReceiverName').value  = receiverName;
        document.getElementById('editReceiverPhone').value = receiverPhone;
        var sel = document.getElementById('editLabel');
        for (var i = 0; i < sel.options.length; i++) { sel.options[i].selected = (sel.options[i].value === label); }
        openModal('modalEdit');
    }
</script>
<script>window.POB_CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/notifications-ws.js"></script>
</body>
</html>
