<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Địa chỉ giao hàng - POB</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', -apple-system, sans-serif; background: #f0f4f8; min-height: 100vh; }

        /* NAVBAR */
        .navbar { background: #fff; border-bottom: 1px solid #e9edf2; box-shadow: 0 1px 6px rgba(26,32,53,0.06); padding: 0 24px; height: 60px; display: flex; align-items: center; gap: 14px; }
        .nav-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .nav-logo-badge { width: 36px; height: 36px; border-radius: 10px; background: linear-gradient(135deg,#1a2035,#2d3a6e); display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 800; font-size: 12px; }
        .nav-title { font-size: 16px; font-weight: 800; color: #0f172a; }
        .nav-right { margin-left: auto; display: flex; align-items: center; gap: 16px; }
        .nav-link { font-size: 13px; font-weight: 500; color: #64748b; text-decoration: none; transition: color 0.2s; }
        .nav-link:hover { color: #10b981; }

        /* PAGE */
        .page-wrap { max-width: 680px; margin: 0 auto; padding: 32px 20px; }

        /* ALERTS */
        .alert { display: flex; align-items: center; gap: 10px; border-radius: 12px; padding: 13px 16px; font-size: 13px; font-weight: 500; margin-bottom: 18px; }
        .alert-success { background: #f0fdf4; border: 1px solid #bbf7d0; color: #16a34a; }
        .alert-error   { background: #fef2f2; border: 1px solid #fecaca; color: #dc2626; }
        .alert-info    { background: #eff6ff; border: 1px solid #bfdbfe; color: #2563eb; }
        .alert-warn    { background: #fffbeb; border: 1px solid #fde68a; color: #92400e; }

        /* HEADER */
        .page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
        .page-title  { font-size: 20px; font-weight: 800; color: #0f172a; }

        .btn-add {
            display: flex; align-items: center; gap: 6px;
            padding: 10px 18px; border-radius: 12px;
            background: linear-gradient(135deg, #10b981, #059669);
            color: #fff; font-size: 13.5px; font-weight: 700;
            border: none; cursor: pointer; font-family: inherit;
            box-shadow: 0 4px 14px rgba(16,185,129,0.3);
            transition: all 0.2s;
        }
        .btn-add:hover { transform: translateY(-1.5px); box-shadow: 0 6px 18px rgba(16,185,129,0.4); }

        /* ADDRESS CARDS */
        .addr-list { display: flex; flex-direction: column; gap: 14px; }

        .addr-card {
            background: #fff; border-radius: 18px;
            border: 1.5px solid #eef0f4;
            box-shadow: 0 2px 10px rgba(26,32,53,0.06);
            padding: 20px 22px;
            position: relative;
            transition: box-shadow 0.18s, transform 0.18s;
        }
        .addr-card:hover { box-shadow: 0 6px 22px rgba(26,32,53,0.1); transform: translateY(-1px); }
        .addr-card.is-default { border-color: #10b981; }

        .default-badge { position: absolute; top: 16px; right: 16px; background: #dcfce7; color: #16a34a; font-size: 11px; font-weight: 700; padding: 4px 12px; border-radius: 99px; }

        .addr-label-row { display: flex; align-items: center; gap: 8px; margin-bottom: 10px; }
        .addr-label-text { font-size: 15px; font-weight: 800; color: #0f172a; }

        .addr-info { margin-bottom: 14px; }
        .addr-full  { font-size: 13.5px; color: #374151; font-weight: 500; margin-bottom: 4px; display: flex; gap: 5px; }
        .addr-person{ font-size: 13px; color: #64748b; display: flex; gap: 8px; }

        .addr-actions { display: flex; gap: 8px; flex-wrap: wrap; padding-top: 14px; border-top: 1px solid #f1f5f9; }
        .addr-btn { display: inline-flex; align-items: center; gap: 5px; padding: 7px 14px; border-radius: 10px; font-size: 12.5px; font-weight: 600; cursor: pointer; border: 1.5px solid; font-family: inherit; transition: all 0.15s; background: transparent; }
        .addr-btn-default { border-color: #10b981; color: #10b981; }
        .addr-btn-default:hover { background: #f0fdf4; }
        .addr-btn-edit    { border-color: #e2e8f0; color: #475569; }
        .addr-btn-edit:hover { background: #f8fafc; }
        .addr-btn-delete  { border-color: #fecaca; color: #dc2626; }
        .addr-btn-delete:hover { background: #fef2f2; }

        /* EMPTY */
        .empty-addr { background: #fff; border: 2px dashed #d4d9e2; border-radius: 20px; padding: 56px 24px; text-align: center; }
        .empty-icon  { font-size: 52px; margin-bottom: 12px; }
        .empty-title { font-size: 16px; font-weight: 600; color: #64748b; margin-bottom: 6px; }
        .empty-sub   { font-size: 13px; color: #94a3b8; margin-bottom: 20px; }

        /* MODALS */
        .modal-overlay {
            position: fixed; inset: 0; background: rgba(15,22,36,0.55);
            backdrop-filter: blur(4px);
            display: flex; align-items: center; justify-content: center;
            z-index: 200; opacity: 0; pointer-events: none; transition: opacity 0.2s;
            padding: 20px;
        }
        .modal-overlay.open { opacity: 1; pointer-events: all; }
        .modal-box {
            background: #fff; border-radius: 20px;
            width: 100%; max-width: 480px;
            padding: 28px; box-shadow: 0 24px 70px rgba(15,22,36,0.22);
            transform: scale(0.96); transition: transform 0.2s;
        }
        .modal-overlay.open .modal-box { transform: scale(1); }

        .modal-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 22px; }
        .modal-title  { font-size: 16px; font-weight: 800; color: #0f172a; }
        .modal-close  { background: none; border: none; cursor: pointer; font-size: 20px; color: #94a3b8; font-weight: 700; line-height: 1; transition: color 0.2s; padding: 2px; }
        .modal-close:hover { color: #0f172a; }

        .form-group   { margin-bottom: 16px; }
        .form-row     { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 16px; }
        .field-label  { display: block; font-size: 11px; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.06em; margin-bottom: 5px; }
        .req          { color: #dc2626; }
        .input-field, .select-field, .textarea-field {
            width: 100%; background: #f8fafc; border: 1.5px solid #e2e8f0;
            border-radius: 12px; padding: 11px 14px;
            font-size: 13.5px; color: #0f172a; font-family: inherit;
            outline: none; transition: border-color 0.2s, box-shadow 0.2s;
        }
        .input-field:focus, .select-field:focus, .textarea-field:focus { border-color: #10b981; background: #fff; box-shadow: 0 0 0 4px rgba(16,185,129,0.1); }
        .textarea-field { resize: none; }

        .checkbox-label { display: flex; align-items: center; gap: 9px; font-size: 13.5px; color: #374151; cursor: pointer; margin-bottom: 16px; }
        .checkbox-label input[type=checkbox] { width: 16px; height: 16px; accent-color: #10b981; border-radius: 4px; cursor: pointer; }

        .modal-actions { display: flex; gap: 10px; padding-top: 4px; }
        .btn-cancel { flex: 0 0 auto; padding: 12px 20px; border-radius: 12px; border: 1.5px solid #e2e8f0; font-size: 13.5px; font-weight: 600; color: #475569; background: transparent; cursor: pointer; font-family: inherit; transition: background 0.15s; }
        .btn-cancel:hover { background: #f1f5f9; }
        .btn-save   { flex: 1; padding: 13px; border-radius: 12px; background: linear-gradient(135deg,#10b981,#059669); color: #fff; font-size: 13.5px; font-weight: 700; border: none; cursor: pointer; font-family: inherit; box-shadow: 0 4px 14px rgba(16,185,129,0.3); transition: all 0.2s; }
        .btn-save:hover { transform: translateY(-1px); box-shadow: 0 6px 18px rgba(16,185,129,0.4); }

        /* DELETE CONFIRM MODAL */
        .confirm-icon  { font-size: 44px; text-align: center; margin-bottom: 12px; }
        .confirm-title { font-size: 18px; font-weight: 800; color: #0f172a; text-align: center; margin-bottom: 8px; }
        .confirm-desc  { font-size: 13.5px; color: #64748b; text-align: center; margin-bottom: 22px; line-height: 1.6; }
        .btn-delete-confirm { flex: 1; padding: 13px; border-radius: 12px; background: linear-gradient(135deg,#ef4444,#dc2626); color: #fff; font-size: 13.5px; font-weight: 700; border: none; cursor: pointer; font-family: inherit; transition: opacity 0.2s; }
        .btn-delete-confirm:hover { opacity: 0.88; }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/user/home" class="nav-logo">
        <div class="nav-logo-badge">POB</div>
    </a>
    <span class="nav-title">Địa chỉ giao hàng</span>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/user/donhang" class="nav-link" style="display:inline-flex;align-items:center;gap:5px;">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
            Đơn hàng
        </a>
        <a href="${pageContext.request.contextPath}/user/home" class="nav-link">← Trang chủ</a>
    </div>
</nav>

<div class="page-wrap">

    <c:if test="${param.success eq 'created'}"><div class="alert alert-success"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg> Đã thêm địa chỉ mới thành công!</div></c:if>
    <c:if test="${param.success eq 'updated'}"><div class="alert alert-success"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg> Đã cập nhật địa chỉ thành công!</div></c:if>
    <c:if test="${param.success eq 'deleted'}"><div class="alert alert-warn"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg> Đã xóa địa chỉ.</div></c:if>
    <c:if test="${param.success eq 'default'}"><div class="alert alert-info"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg> Đã đặt làm địa chỉ mặc định!</div></c:if>
    <c:if test="${param.error eq 'missing'}"><div class="alert alert-error"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg> Vui lòng điền đầy đủ thông tin bắt buộc.</div></c:if>

    <div class="page-header">
        <div class="page-title">Địa chỉ của tôi</div>
        <button class="btn-add" onclick="openModal('modalCreate')">+ Thêm địa chỉ mới</button>
    </div>

    <c:choose>
        <c:when test="${empty addresses}">
            <div class="empty-addr">
                <div class="empty-icon"><svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#cbd5e1" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="margin:0 auto;"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg></div>
                <div class="empty-title">Bạn chưa có địa chỉ nào.</div>
                <div class="empty-sub">Thêm địa chỉ để đặt hàng nhanh hơn.</div>
                <button class="btn-add" style="margin:0 auto;" onclick="openModal('modalCreate')">+ Thêm địa chỉ mới</button>
            </div>
        </c:when>
        <c:otherwise>
            <div class="addr-list">
                <c:forEach var="addr" items="${addresses}">
                    <div class="addr-card ${addr.isDefault ? 'is-default' : ''}">

                        <c:if test="${addr.isDefault}">
                            <span class="default-badge" style="display:inline-flex;align-items:center;gap:4px;">
                                <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                Mặc định</span>
                        </c:if>

                        <div class="addr-label-row">
                            <span class="addr-label-text" style="display:inline-flex;align-items:center;gap:7px;">
                                <c:choose>
                                    <c:when test="${addr.label eq 'Nhà'}"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg></c:when>
                                    <c:when test="${addr.label eq 'Công ty'}"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="2" width="16" height="20" rx="1"/><path d="M9 22v-4h6v4M8 6h.01M12 6h.01M16 6h.01M8 10h.01M12 10h.01M16 10h.01M8 14h.01M12 14h.01M16 14h.01"/></svg></c:when>
                                    <c:when test="${addr.label eq 'Trường học'}"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 10L12 5 2 10l10 5 10-5v6"/><path d="M6 12v5c0 1.1 2.7 3 6 3s6-1.9 6-3v-5"/></svg></c:when>
                                    <c:otherwise><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg></c:otherwise>
                                </c:choose>
                                <c:out value="${addr.label}"/>
                            </span>
                        </div>

                        <div class="addr-info">
                            <div class="addr-full"><span style="display:inline-flex;flex-shrink:0;"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg></span><span><c:out value="${addr.fullAddress}"/></span></div>
                            <div class="addr-person">
                                <span style="display:inline-flex;align-items:center;gap:4px;"><svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg> <c:out value="${addr.receiverName}"/></span>
                                <span>·</span>
                                <span style="display:inline-flex;align-items:center;gap:4px;"><svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/></svg> <c:out value="${addr.receiverPhone}"/></span>
                            </div>
                        </div>

                        <div class="addr-actions">
                            <c:if test="${!addr.isDefault}">
                                <form action="${pageContext.request.contextPath}/user/dia-chi" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="setDefault">
                                    <input type="hidden" name="id" value="${addr.id}">
                                    <button type="submit" class="addr-btn addr-btn-default" style="display:inline-flex;align-items:center;gap:4px;">
                                        <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                        Đặt mặc định</button>
                                </form>
                            </c:if>

                            <button class="addr-btn addr-btn-edit" style="display:inline-flex;align-items:center;gap:4px;"
                                    onclick="openEdit(${addr.id}, '${addr.label}', '${addr.fullAddress}', '${addr.receiverName}', '${addr.receiverPhone}', ${empty addr.locationX ? 'null' : addr.locationX}, ${empty addr.locationY ? 'null' : addr.locationY})">
                                <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.12 2.12 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                Sửa
                            </button>

                            <c:if test="${!addr.isDefault}">
                                <button class="addr-btn addr-btn-delete" style="display:inline-flex;align-items:center;gap:4px;"
                                        onclick="openDeleteConfirm(${addr.id})">
                                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                                    Xóa
                                </button>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- MODAL THÊM -->
<div class="modal-overlay" id="modalCreate" onclick="closeOnBg(event,'modalCreate')">
    <div class="modal-box">
        <div class="modal-header">
            <span class="modal-title" style="display:inline-flex;align-items:center;gap:7px;">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                Thêm địa chỉ mới</span>
            <button class="modal-close" onclick="closeModal('modalCreate')">✕</button>
        </div>
        <form action="${pageContext.request.contextPath}/user/dia-chi" method="post" onsubmit="return validateAddressForm('createLat','createLng')">
            <input type="hidden" name="action" value="create">

            <div class="form-group">
                <label class="field-label">Nhãn địa chỉ</label>
                <select name="label" class="select-field">
                    <option value="Nhà">Nhà</option>
                    <option value="Công ty">Công ty</option>
                    <option value="Trường học">Trường học</option>
                    <option value="Khác">Khác</option>
                </select>
            </div>

            <div class="form-group">
                <label class="field-label">Địa chỉ đầy đủ <span class="req">*</span></label>
                <textarea name="fullAddress" id="createFullAddress" rows="2" required placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố" class="textarea-field"></textarea>
            </div>

            <div class="form-group">
                <button type="button" class="addr-btn addr-btn-edit" style="display:inline-flex;align-items:center;gap:5px;" onclick="toggleMap('createMapWrapper','createMap','createLat','createLng','createFullAddress', null, null)">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                    Chọn trên bản đồ</button>
                <div id="createMapWrapper" style="display:none; margin-top:10px;">
                    <div style="display:flex; gap:8px; margin-bottom:8px;">
                        <input type="text" id="createMapSearchInput" class="input-field" placeholder="Tìm địa chỉ...">
                        <button type="button" id="createMapSearchBtn" class="btn-cancel">Tìm</button>
                    </div>
                    <div id="createMap" style="height:280px; border-radius:12px; overflow:hidden;"></div>
                </div>
                <input type="hidden" name="locationX" id="createLat">
                <input type="hidden" name="locationY" id="createLng">
            </div>

            <div class="form-row">
                <div>
                    <label class="field-label">Tên người nhận <span class="req">*</span></label>
                    <input type="text" name="receiverName" required placeholder="Họ và tên" class="input-field">
                </div>
                <div>
                    <label class="field-label">Số điện thoại <span class="req">*</span></label>
                    <input type="tel" name="receiverPhone" required placeholder="0xxxxxxxxx" class="input-field">
                </div>
            </div>

            <label class="checkbox-label">
                <input type="checkbox" name="isDefault" value="true">
                <span>Đặt làm địa chỉ mặc định</span>
            </label>

            <div class="modal-actions">
                <button type="button" class="btn-cancel" onclick="closeModal('modalCreate')">Hủy</button>
                <button type="submit" class="btn-save">Lưu địa chỉ</button>
            </div>
        </form>
    </div>
</div>

<!-- MODAL SỬA -->
<div class="modal-overlay" id="modalEdit" onclick="closeOnBg(event,'modalEdit')">
    <div class="modal-box">
        <div class="modal-header">
            <span class="modal-title" style="display:inline-flex;align-items:center;gap:7px;">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.12 2.12 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                Chỉnh sửa địa chỉ</span>
            <button class="modal-close" onclick="closeModal('modalEdit')">✕</button>
        </div>
        <form action="${pageContext.request.contextPath}/user/dia-chi" method="post" onsubmit="return validateAddressForm('editLat','editLng')">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" id="editId">

            <div class="form-group">
                <label class="field-label">Nhãn địa chỉ</label>
                <select name="label" id="editLabel" class="select-field">
                    <option value="Nhà">Nhà</option>
                    <option value="Công ty">Công ty</option>
                    <option value="Trường học">Trường học</option>
                    <option value="Khác">Khác</option>
                </select>
            </div>

            <div class="form-group">
                <label class="field-label">Địa chỉ đầy đủ <span class="req">*</span></label>
                <textarea name="fullAddress" id="editFullAddress" rows="2" required class="textarea-field"></textarea>
            </div>

            <div class="form-group">
                <button type="button" class="addr-btn addr-btn-edit" style="display:inline-flex;align-items:center;gap:5px;" onclick="toggleMap('editMapWrapper','editMap','editLat','editLng','editFullAddress', window.editPresetLat, window.editPresetLng)">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                    Chọn trên bản đồ</button>
                <div id="editMapWrapper" style="display:none; margin-top:10px;">
                    <div style="display:flex; gap:8px; margin-bottom:8px;">
                        <input type="text" id="editMapSearchInput" class="input-field" placeholder="Tìm địa chỉ...">
                        <button type="button" id="editMapSearchBtn" class="btn-cancel">Tìm</button>
                    </div>
                    <div id="editMap" style="height:280px; border-radius:12px; overflow:hidden;"></div>
                </div>
                <input type="hidden" name="locationX" id="editLat">
                <input type="hidden" name="locationY" id="editLng">
            </div>

            <div class="form-row">
                <div>
                    <label class="field-label">Tên người nhận <span class="req">*</span></label>
                    <input type="text" name="receiverName" id="editReceiverName" required class="input-field">
                </div>
                <div>
                    <label class="field-label">Số điện thoại <span class="req">*</span></label>
                    <input type="tel" name="receiverPhone" id="editReceiverPhone" required class="input-field">
                </div>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn-cancel" onclick="closeModal('modalEdit')">Hủy</button>
                <button type="submit" class="btn-save">Cập nhật</button>
            </div>
        </form>
    </div>
</div>

<!-- MODAL XÁC NHẬN XÓA -->
<div class="modal-overlay" id="modalDelete" onclick="closeOnBg(event,'modalDelete')">
    <div class="modal-box" style="max-width:400px;">
        <div class="confirm-icon"><svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#dc2626" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="margin:0 auto;"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg></div>
        <div class="confirm-title">Xóa địa chỉ này?</div>
        <div class="confirm-desc">Hành động này không thể hoàn tác. Địa chỉ sẽ bị xóa vĩnh viễn.</div>
        <form action="${pageContext.request.contextPath}/user/dia-chi" method="post" id="deleteForm">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="id" id="deleteAddrId">
            <div class="modal-actions">
                <button type="button" class="btn-cancel" onclick="closeModal('modalDelete')">Hủy bỏ</button>
                <button type="submit" class="btn-delete-confirm">Xóa địa chỉ</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal(id) {
        document.getElementById(id).classList.add('open');
        document.body.style.overflow = 'hidden';
    }
    function closeModal(id) {
        document.getElementById(id).classList.remove('open');
        document.body.style.overflow = '';
    }
    function closeOnBg(e, id) {
        if (e.target === document.getElementById(id)) closeModal(id);
    }

    function openEdit(id, label, fullAddress, receiverName, receiverPhone, locationX, locationY) {
        document.getElementById('editId').value           = id;
        document.getElementById('editFullAddress').value  = fullAddress;
        document.getElementById('editReceiverName').value = receiverName;
        document.getElementById('editReceiverPhone').value= receiverPhone;
        document.getElementById('editLat').value = (locationX === null || locationX === undefined) ? '' : locationX;
        document.getElementById('editLng').value = (locationY === null || locationY === undefined) ? '' : locationY;
        window.editPresetLat = locationX;
        window.editPresetLng = locationY;
        var sel = document.getElementById('editLabel');
        for (var i = 0; i < sel.options.length; i++) sel.options[i].selected = sel.options[i].value === label;
        openModal('modalEdit');
    }

    function openDeleteConfirm(id) {
        document.getElementById('deleteAddrId').value = id;
        openModal('modalDelete');
    }

    function initAddressMap(containerId, latInputId, lngInputId, addressFieldId, presetLat, presetLng) {
        var mapContainer = document.getElementById(containerId);
        if (mapContainer.dataset.initialized === 'true') {
            var existingMap = mapContainer._leafletMap;
            setTimeout(function () { existingMap.invalidateSize(); }, 50);
            return;
        }
        mapContainer.dataset.initialized = 'true';

        var defaultLat = 21.0285, defaultLng = 105.8542;
        var startLat = presetLat ? parseFloat(presetLat) : defaultLat;
        var startLng = presetLng ? parseFloat(presetLng) : defaultLng;

        var map = L.map(containerId).setView([startLat, startLng], 15);
        mapContainer._leafletMap = map;

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors',
            maxZoom: 19
        }).addTo(map);

        var marker = null;
        var reverseGeocodeTimer = null;

        function updateCoords(lat, lng) {
            document.getElementById(latInputId).value = lat;
            document.getElementById(lngInputId).value = lng;
        }

        function reverseGeocode(lat, lng) {
            fetch('https://nominatim.openstreetmap.org/reverse?format=json&lat=' + lat + '&lon=' + lng)
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    if (data && data.display_name) {
                        document.getElementById(addressFieldId).value = data.display_name;
                    }
                })
                .catch(function () {
                    console.warn('Khong the lay dia chi tu toa do');
                });
        }

        function reverseGeocodeDebounced(lat, lng) {
            clearTimeout(reverseGeocodeTimer);
            reverseGeocodeTimer = setTimeout(function () {
                reverseGeocode(lat, lng);
            }, 500);
        }

        function placeMarker(lat, lng, doReverseGeocode) {
            if (marker) {
                marker.setLatLng([lat, lng]);
            } else {
                marker = L.marker([lat, lng], { draggable: true }).addTo(map);
                marker.on('dragend', function () {
                    var pos = marker.getLatLng();
                    updateCoords(pos.lat, pos.lng);
                    reverseGeocodeDebounced(pos.lat, pos.lng);
                });
            }
            updateCoords(lat, lng);
            if (doReverseGeocode) reverseGeocode(lat, lng);
        }

        map.on('click', function (e) {
            placeMarker(e.latlng.lat, e.latlng.lng, true);
        });

        if (presetLat && presetLng) {
            placeMarker(startLat, startLng, false);
        } else if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function (pos) { map.setView([pos.coords.latitude, pos.coords.longitude], 15); },
                function () { /* denied - keep default center */ },
                { timeout: 5000 }
            );
        }

        document.getElementById(containerId + 'SearchBtn').addEventListener('click', function () {
            var query = document.getElementById(containerId + 'SearchInput').value.trim();
            if (!query) return;
            fetch('https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(query) + '&limit=1')
                .then(function (res) { return res.json(); })
                .then(function (results) {
                    if (results && results.length > 0) {
                        var lat = parseFloat(results[0].lat);
                        var lng = parseFloat(results[0].lon);
                        map.setView([lat, lng], 16);
                        placeMarker(lat, lng, true);
                    } else {
                        alert('Không tìm thấy địa chỉ, vui lòng thử tên khác');
                    }
                })
                .catch(function () {
                    alert('Không tìm được địa chỉ, vui lòng thử lại');
                });
        });
    }

    function toggleMap(wrapperId, containerId, latInputId, lngInputId, addressFieldId, presetLat, presetLng) {
        document.getElementById(wrapperId).style.display = 'block';
        setTimeout(function () {
            initAddressMap(containerId, latInputId, lngInputId, addressFieldId, presetLat, presetLng);
        }, 50);
    }

    function validateAddressForm(latInputId, lngInputId) {
        var lat = document.getElementById(latInputId).value;
        var lng = document.getElementById(lngInputId).value;
        if (!lat || !lng) {
            alert('Vui lòng chọn vị trí trên bản đồ trước khi lưu.');
            return false;
        }
        return true;
    }
</script>
    <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</body>
</html>
