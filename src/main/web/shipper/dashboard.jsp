<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - POB Shipper</title>
    <style>
        :root[data-theme="dark"] {
            --bg-base:#0f172a;--bg-card:#1e293b;--bg-input:#0f172a;
            --text-main:#f8fafc;--text-muted:#94a3b8;--border-color:#334155;
            --topbar-bg:rgba(30,41,59,0.8);--shadow:0 4px 6px -1px rgb(0 0 0/.2);
        }
        :root[data-theme="light"] {
            --bg-base:#f4f7f5;--bg-card:#ffffff;--bg-input:#f8fafc;
            --text-main:#1e293b;--text-muted:#64748b;--border-color:#e2e8f0;
            --topbar-bg:rgba(255,255,255,0.85);--shadow:0 4px 12px rgba(0,0,0,.03);
        }
        :root {
            --primary:#4CAF50;--primary-hover:#43a047;--primary-light:rgba(76,175,80,.12);
            --secondary:#FF9800;--secondary-hover:#f57c00;--secondary-light:rgba(255,152,0,.12);
            --danger:#ef4444;
            --font-family:system-ui,-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;
        }
        *{box-sizing:border-box;margin:0;padding:0;font-family:var(--font-family);transition:background-color .25s,border-color .25s}
        body{background:var(--bg-base);color:var(--text-main);display:flex;height:100vh;overflow:hidden}
        a{text-decoration:none;color:inherit}

        /* SIDEBAR */
        .sidebar{width:260px;background:var(--bg-card);border-right:1px solid var(--border-color);display:flex;flex-direction:column;flex-shrink:0;z-index:10}
        .brand{padding:24px;display:flex;align-items:center;gap:12px;border-bottom:1px solid var(--border-color)}
        .logo{background:linear-gradient(135deg,var(--primary),#2e7d32);color:#fff;width:38px;height:38px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:18px;box-shadow:0 4px 10px rgba(76,175,80,.3)}
        .brand-title{font-weight:700;font-size:16px;letter-spacing:.5px}
        .menu{padding:20px 12px;flex:1}
        .menu-item{padding:14px 16px;display:flex;align-items:center;gap:12px;color:var(--text-muted);font-size:14px;font-weight:600;border-radius:8px;margin-bottom:6px}
        .menu-item:hover{background:var(--bg-input);color:var(--text-main);transform:translateX(4px)}
        .menu-item.active{background:var(--primary-light);color:var(--primary)}
        .online-toggle-wrap{padding:16px 12px;border-top:1px solid var(--border-color)}
        .online-toggle-btn{width:100%;padding:12px 16px;border-radius:10px;border:none;cursor:pointer;display:flex;align-items:center;gap:10px;font-size:13px;font-weight:700;transition:all .2s}
        .online-toggle-btn.is-online{background:var(--primary-light);color:var(--primary);border:1.5px solid var(--primary)}
        .online-toggle-btn.is-offline{background:rgba(239,68,68,.08);color:#ef4444;border:1.5px solid rgba(239,68,68,.3)}
        .toggle-dot{width:10px;height:10px;border-radius:50%;flex-shrink:0}
        .toggle-dot.online{background:var(--primary);animation:pulse-green 1.5s infinite}
        .toggle-dot.offline{background:#ef4444}
        @keyframes pulse-green{0%,100%{box-shadow:0 0 0 3px rgba(76,175,80,.25)}50%{box-shadow:0 0 0 6px rgba(76,175,80,.1)}}

        /* MAIN */
        .main{flex:1;display:flex;flex-direction:column;overflow:hidden}
        .topbar{background:var(--topbar-bg);backdrop-filter:blur(10px);padding:16px 32px;display:flex;justify-content:space-between;align-items:center;border-bottom:1px solid var(--border-color)}
        .topbar h1{font-size:18px;font-weight:700;display:flex;align-items:center;gap:8px}
        .topbar-right{display:flex;align-items:center;gap:16px}
        .theme-toggle{background:var(--bg-input);border:1px solid var(--border-color);width:38px;height:38px;border-radius:8px;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:16px}
        .avatar-circle{background:var(--primary);color:white;width:38px;height:38px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:700}
        .btn-logout{padding:8px 16px;border-radius:8px;background:rgba(239,68,68,.1);color:var(--danger);font-size:13px;font-weight:600}
        .btn-logout:hover{background:var(--danger);color:white}

        /* CONTENT */
        .content{padding:24px 32px;overflow-y:auto;flex:1;display:flex;flex-direction:column;gap:24px;animation:fadeIn .3s ease-out}
        @keyframes fadeIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}

        /* STAT CARDS */
        .stats-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:16px}
        .stat-card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:14px;padding:20px;box-shadow:var(--shadow);display:flex;justify-content:space-between;align-items:center}
        .stat-label{font-size:11px;color:var(--text-muted);font-weight:700;text-transform:uppercase;letter-spacing:.5px}
        .stat-num{font-size:22px;font-weight:800;margin-top:4px}
        .stat-icon{width:42px;height:42px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:18px}

        /* SECTION TITLE */
        .section-title{font-size:14px;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.5px;margin-bottom:14px;padding-bottom:10px;border-bottom:1px solid var(--border-color)}

        /* CHART CARD */
        .chart-card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:14px;padding:24px;box-shadow:var(--shadow)}

        /* TABLE */
        .table-card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:14px;padding:24px;box-shadow:var(--shadow)}
        table{width:100%;border-collapse:collapse;font-size:13px}
        th{text-align:left;padding:10px 12px;font-size:11px;font-weight:700;text-transform:uppercase;color:var(--text-muted);border-bottom:2px solid var(--border-color)}
        td{padding:12px;border-bottom:1px solid var(--border-color);font-weight:500}
        tr:last-child td{border-bottom:none}
        tr:hover td{background:var(--bg-input)}
        .badge{padding:3px 8px;border-radius:6px;font-size:11px;font-weight:700}
        .badge-cod{background:var(--secondary-light);color:var(--secondary)}
        .badge-bank{background:rgba(59,130,246,.1);color:#3b82f6}
        .badge-payos{background:rgba(139,92,246,.1);color:#8b5cf6}

        @media(max-width:768px){
            body{flex-direction:column}
            .sidebar{width:100%;height:auto;border-right:none;border-bottom:1px solid var(--border-color)}
            .menu{display:flex;overflow-x:auto;padding:10px}
            .menu-item{margin-bottom:0;white-space:nowrap}
            .content{padding:16px}
            .stats-grid{grid-template-columns:repeat(2,1fr)}
        }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="brand">
        <div class="logo">🛵</div>
        <div>
            <div class="brand-title">POB SHIPPER</div>
            <c:choose>
                <c:when test="${sessionScope.account.online}">
                    <div style="font-size:10px;color:var(--primary);font-weight:bold;">● ĐANG HOẠT ĐỘNG</div>
                </c:when>
                <c:otherwise>
                    <div style="font-size:10px;color:#ef4444;font-weight:bold;">● NGOẠI TUYẾN</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <ul class="menu">
        <a href="${pageContext.request.contextPath}/shipper/donhang">
            <li class="menu-item"><span>📋 Đơn hàng nhận</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/dashboard">
            <li class="menu-item active"><span>📊 Dashboard</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/thongbao">
            <li class="menu-item"><span>🔔 Thông báo</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/profile">
            <li class="menu-item"><span>👤 Hồ sơ tài xế</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/danh-gia">
            <li class="menu-item"><span>⭐ Đánh giá & Báo cáo</span></li>
        </a>
    </ul>
    <div class="online-toggle-wrap">
        <form action="${pageContext.request.contextPath}/shipper/status" method="post">
            <c:choose>
                <c:when test="${sessionScope.account.online}">
                    <button type="submit" class="online-toggle-btn is-online"
                            onclick="return confirm('Tắt chế độ Online? Bạn sẽ không nhận đơn mới.')">
                        <span class="toggle-dot online"></span>Đang Online — Nhấn để Offline
                    </button>
                </c:when>
                <c:otherwise>
                    <button type="submit" class="online-toggle-btn is-offline">
                        <span class="toggle-dot offline"></span>Đang Offline — Nhấn để Online
                    </button>
                </c:otherwise>
            </c:choose>
        </form>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <h1>📊 Dashboard Thu nhập</h1>
        <div class="topbar-right">
            <button type="button" class="theme-toggle" id="themeToggleBtn">🌓</button>
            <div class="avatar-circle">
                <c:choose>
                    <c:when test="${not empty tenShipper}">${fn:toUpperCase(fn:substring(tenShipper,0,1))}</c:when>
                    <c:otherwise>S</c:otherwise>
                </c:choose>
            </div>
            <span style="font-size:13px;font-weight:600;">${tenShipper}</span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng xuất</a>
        </div>
    </header>

    <div class="content">

        <%-- Stat cards hàng 1: Thu nhập --%>
        <div>
            <div class="section-title">💰 Thu nhập (phí ship)</div>
            <div class="stats-grid">
                <div class="stat-card">
                    <div>
                        <div class="stat-label">Hôm nay</div>
                        <div class="stat-num" style="color:var(--primary);">
                            <fmt:formatNumber value="${thuHomNay}" type="number" maxFractionDigits="0"/>đ
                        </div>
                    </div>
                    <div class="stat-icon" style="background:var(--primary-light);color:var(--primary);">💵</div>
                </div>
                <div class="stat-card">
                    <div>
                        <div class="stat-label">Tuần này</div>
                        <div class="stat-num" style="color:var(--primary);">
                            <fmt:formatNumber value="${thuTuanNay}" type="number" maxFractionDigits="0"/>đ
                        </div>
                    </div>
                    <div class="stat-icon" style="background:var(--primary-light);color:var(--primary);">📅</div>
                </div>
                <div class="stat-card">
                    <div>
                        <div class="stat-label">Tháng này</div>
                        <div class="stat-num" style="color:var(--primary);">
                            <fmt:formatNumber value="${thuThangNay}" type="number" maxFractionDigits="0"/>đ
                        </div>
                    </div>
                    <div class="stat-icon" style="background:var(--primary-light);color:var(--primary);">🗓️</div>
                </div>
            </div>
        </div>

        <%-- Stat cards hàng 2: Đơn hàng --%>
        <div>
            <div class="section-title">📦 Thống kê đơn hàng</div>
            <div class="stats-grid">
                <div class="stat-card">
                    <div>
                        <div class="stat-label">Hôm nay</div>
                        <div class="stat-num">${donHomNay} đơn</div>
                    </div>
                    <div class="stat-icon" style="background:var(--primary-light);color:var(--primary);">✓</div>
                </div>
                <div class="stat-card">
                    <div>
                        <div class="stat-label">Tuần này</div>
                        <div class="stat-num">${donTuanNay} đơn</div>
                    </div>
                    <div class="stat-icon" style="background:rgba(59,130,246,.1);color:#3b82f6;">📆</div>
                </div>
                <div class="stat-card">
                    <div>
                        <div class="stat-label">Tháng này</div>
                        <div class="stat-num">${donThangNay} đơn</div>
                    </div>
                    <div class="stat-icon" style="background:rgba(139,92,246,.1);color:#8b5cf6;">🗃️</div>
                </div>
                <div class="stat-card">
                    <div>
                        <div class="stat-label">Tổng tất cả</div>
                        <div class="stat-num">${tongDon} đơn</div>
                    </div>
                    <div class="stat-icon" style="background:var(--secondary-light);color:var(--secondary);">🏆</div>
                </div>
                <div class="stat-card">
                    <div>
                        <div class="stat-label">Chờ lấy hàng</div>
                        <div class="stat-num" style="color:var(--secondary);">${dangChoLayHang} đơn</div>
                    </div>
                    <div class="stat-icon" style="background:var(--secondary-light);color:var(--secondary);">📦</div>
                </div>
                <div class="stat-card">
                    <div>
                        <div class="stat-label">Đang giao</div>
                        <div class="stat-num" style="color:var(--primary);">${dangGiao} đơn</div>
                    </div>
                    <div class="stat-icon" style="background:var(--primary-light);color:var(--primary);">🛵</div>
                </div>
            </div>
        </div>

        <%-- Biểu đồ thu nhập 7 ngày --%>
        <div class="chart-card">
            <div class="section-title">📈 Thu nhập 7 ngày gần đây</div>
            <canvas id="revenueChart" height="90"></canvas>
        </div>

        <%-- Bảng 10 đơn gần nhất --%>
        <div class="table-card">
            <div class="section-title">🕐 10 đơn hoàn thành gần nhất</div>
            <c:choose>
                <c:when test="${empty recentDone}">
                    <div style="text-align:center;padding:32px;color:var(--text-muted);">
                        Chưa có đơn hàng nào hoàn thành.
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="overflow-x:auto;">
                        <table>
                            <thead>
                                <tr>
                                    <th>#Mã đơn</th>
                                    <th>Cửa hàng</th>
                                    <th>Người nhận</th>
                                    <th>Tổng đơn</th>
                                    <th>Phí ship</th>
                                    <th>Hình thức TT</th>
                                    <th>Thời gian</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="row" items="${recentDone}">
                                    <tr>
                                        <td style="font-weight:700;">#${row.id}</td>
                                        <td>${row.shopName}</td>
                                        <td>${row.receiverName}</td>
                                        <td style="font-weight:700;color:var(--primary);">
                                            <fmt:formatNumber value="${row.totalPrice}" type="number" maxFractionDigits="0"/>đ
                                        </td>
                                        <td style="font-weight:700;color:var(--secondary);">
                                            <fmt:formatNumber value="${row.deliveryFee}" type="number" maxFractionDigits="0"/>đ
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${row.paymentMethod == 'PAYOS'}">
                                                    <span class="badge badge-payos">🏦 PayOS</span>
                                                </c:when>
                                                <c:when test="${row.paymentMethod == 'BANK'}">
                                                    <span class="badge badge-bank">📱 QR</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-cod">💵 COD</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:12px;">${row.createdAt}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
    // --- THEME ---
    const html = document.documentElement;
    html.setAttribute('data-theme', localStorage.getItem('shipper-theme') || 'light');
    document.getElementById('themeToggleBtn').addEventListener('click', () => {
        const t = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        html.setAttribute('data-theme', t);
        localStorage.setItem('shipper-theme', t);
        updateChartTheme();
    });

    // --- CHART ---
    const labels   = ${chartLabels};
    const dataVals = ${chartData};

    const ctx = document.getElementById('revenueChart').getContext('2d');
    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Phí ship (đ)',
                data: dataVals,
                backgroundColor: 'rgba(76,175,80,0.7)',
                borderColor:     'rgba(76,175,80,1)',
                borderWidth: 2,
                borderRadius: 6,
                borderSkipped: false,
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: ctx => ctx.parsed.y.toLocaleString('vi-VN') + 'đ'
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: v => v.toLocaleString('vi-VN') + 'đ',
                        color: getComputedStyle(document.documentElement).getPropertyValue('--text-muted').trim()
                    },
                    grid: { color: 'rgba(128,128,128,0.15)' }
                },
                x: {
                    ticks: {
                        color: getComputedStyle(document.documentElement).getPropertyValue('--text-muted').trim()
                    },
                    grid: { display: false }
                }
            }
        }
    });

    function updateChartTheme() {
        const muted = getComputedStyle(document.documentElement).getPropertyValue('--text-muted').trim();
        chart.options.scales.y.ticks.color = muted;
        chart.options.scales.x.ticks.color = muted;
        chart.update();
    }
</script>
</body>
</html>
