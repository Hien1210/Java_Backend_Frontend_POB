/* Easter egg trang Super Admin: nut goc man hinh tha 1 chu meo pixel chay tu PHAI sang TRAI o duoi
   man hinh. Sau khi meo chay khuat, hien 1 nut o cho meo bien mat -> bam vao mo trang thong tin
   cac thanh vien nhom. Khong cho spam: nut bi khoa trong luc meo dang chay. */
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

    var CAT_BOTTOM = 24; /* mac dinh meo chay o duoi man hinh */

    if (!document.getElementById(STYLE_ID)) {
        var style = document.createElement('style');
        style.id = STYLE_ID;
        style.textContent = [
            /* nut tha meo */
            '.pixel-cat-trigger{position:fixed;top:90px;right:24px;z-index:2000;width:48px;height:48px;',
            'border-radius:50%;border:2px solid var(--border-color,#333);background:var(--bg-panel,#fff);',
            'box-shadow:0 4px 14px rgba(0,0,0,.18);cursor:pointer;font-size:22px;display:flex;',
            'align-items:center;justify-content:center;transition:transform .15s ease,opacity .2s ease;}',
            '.pixel-cat-trigger:hover{transform:scale(1.1);}',
            '.pixel-cat-trigger:active{transform:scale(.92);}',
            '.pixel-cat-trigger[disabled]{opacity:.35;cursor:not-allowed;pointer-events:none;}',

            /* con meo */
            '.pixel-cat-runway{position:fixed;left:0;bottom:' + CAT_BOTTOM + 'px;width:100vw;z-index:1999;pointer-events:none;}',
            '.pixel-cat{position:absolute;width:64px;height:40px;image-rendering:pixelated;',
            'animation:pixelCatRun linear forwards, pixelCatBob .28s steps(2) infinite;}',
            '.pixel-cat .pc-part{position:absolute;}',
            '.pixel-cat .pc-body{left:12px;top:16px;width:32px;height:16px;background:#e08a3e;}',
            '.pixel-cat .pc-belly{left:16px;top:24px;width:20px;height:8px;background:#f5d9b0;}',
            '.pixel-cat .pc-stripe1{left:20px;top:16px;width:4px;height:16px;background:#b8672a;}',
            '.pixel-cat .pc-stripe2{left:32px;top:16px;width:4px;height:16px;background:#b8672a;}',
            '.pixel-cat .pc-head{left:40px;top:8px;width:20px;height:16px;background:#e08a3e;}',
            '.pixel-cat .pc-ear-l{left:42px;top:0px;width:6px;height:8px;background:#e08a3e;',
            'clip-path:polygon(0 100%,50% 0,100% 100%);}',
            '.pixel-cat .pc-ear-r{left:52px;top:0px;width:6px;height:8px;background:#e08a3e;',
            'clip-path:polygon(0 100%,50% 0,100% 100%);}',
            '.pixel-cat .pc-eye{left:52px;top:14px;width:3px;height:3px;background:#222;}',
            '.pixel-cat .pc-nose{left:58px;top:16px;width:3px;height:3px;background:#c0432c;}',
            '.pixel-cat .pc-tail{left:2px;top:8px;width:6px;height:16px;background:#e08a3e;',
            'border-radius:3px;transform-origin:bottom center;animation:pixelCatTail .3s ease-in-out infinite alternate;}',
            '.pixel-cat .pc-leg{position:absolute;bottom:0;width:4px;height:8px;background:#3a2418;}',
            '.pixel-cat .pc-leg-1{left:16px;animation:pixelCatLegA .28s steps(2) infinite;}',
            '.pixel-cat .pc-leg-2{left:24px;animation:pixelCatLegB .28s steps(2) infinite;}',
            '.pixel-cat .pc-leg-3{left:42px;animation:pixelCatLegB .28s steps(2) infinite;}',
            '.pixel-cat .pc-leg-4{left:50px;animation:pixelCatLegA .28s steps(2) infinite;}',
            /* meo doi huong: chay tu PHAI sang TRAI, scaleX(-1) de dau quay ve huong di (trai) */
            '@keyframes pixelCatRun{from{transform:translateX(calc(100vw + 90px)) scaleX(-1);}',
            'to{transform:translateX(-90px) scaleX(-1);}}',
            '@keyframes pixelCatBob{0%,100%{margin-top:0;}50%{margin-top:-3px;}}',
            '@keyframes pixelCatTail{from{transform:rotate(-15deg);}to{transform:rotate(15deg);}}',
            '@keyframes pixelCatLegA{0%,100%{height:8px;}50%{height:3px;}}',
            '@keyframes pixelCatLegB{0%,100%{height:3px;}50%{height:8px;}}',

            /* nut hien ra o cho meo bien mat (goc trai man hinh) */
            '.pixel-cat-reveal{position:fixed;left:14px;bottom:' + (CAT_BOTTOM - 4) + 'px;z-index:2000;',
            'display:flex;align-items:center;gap:8px;padding:10px 16px 10px 12px;border-radius:999px;',
            'border:2px solid var(--primary,#10b981);background:var(--bg-panel,#fff);color:var(--text-main,#0f172a);',
            'font-size:13px;font-weight:700;cursor:pointer;box-shadow:0 6px 18px rgba(0,0,0,.2);',
            'animation:pixelCatRevealIn .35s ease both;}',
            '.pixel-cat-reveal:hover{transform:translateY(-2px);box-shadow:0 10px 22px rgba(0,0,0,.24);}',
            '.pixel-cat-reveal .pcr-emoji{font-size:20px;}',
            '@keyframes pixelCatRevealIn{from{opacity:0;transform:translateX(-16px) scale(.85);}',
            'to{opacity:1;transform:translateX(0) scale(1);}}',

            /* modal thong tin nhom */
            '.pixel-cat-overlay{position:fixed;inset:0;z-index:3000;background:rgba(10,14,20,.6);',
            'display:flex;align-items:center;justify-content:center;padding:24px;',
            'animation:pixelCatFade .2s ease both;backdrop-filter:blur(2px);}',
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

    var catRunning = false;

    function spawnCat(onDone) {
        var runway = document.createElement('div');
        runway.className = 'pixel-cat-runway';

        var cat = document.createElement('div');
        cat.className = 'pixel-cat';
        cat.style.animationDuration = (4 + Math.random() * 1.5) + 's, .28s';
        cat.innerHTML =
            '<div class="pc-part pc-tail"></div>' +
            '<div class="pc-leg pc-leg-1"></div>' +
            '<div class="pc-leg pc-leg-2"></div>' +
            '<div class="pc-leg pc-leg-3"></div>' +
            '<div class="pc-leg pc-leg-4"></div>' +
            '<div class="pc-part pc-body"></div>' +
            '<div class="pc-part pc-belly"></div>' +
            '<div class="pc-part pc-stripe1"></div>' +
            '<div class="pc-part pc-stripe2"></div>' +
            '<div class="pc-part pc-head"></div>' +
            '<div class="pc-part pc-ear-l"></div>' +
            '<div class="pc-part pc-ear-r"></div>' +
            '<div class="pc-part pc-eye"></div>' +
            '<div class="pc-part pc-nose"></div>';

        runway.appendChild(cat);
        document.body.appendChild(runway);
        cat.addEventListener('animationend', function (e) {
            if (e.animationName === 'pixelCatRun') {
                runway.remove();
                if (onDone) onDone();
            }
        });
    }

    function buildTeamModal() {
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
                    '<h2>🐾 Nhóm phát triển dự án</h2>' +
                    '<p>Đội ngũ thực hiện đồ án — vai trò &amp; công việc phụ trách</p>' +
                '</div>' +
                '<div class="pcm-grid">' + cardsHtml + '</div>' +
            '</div>';

        function close() {
            overlay.remove();
            document.removeEventListener('keydown', onKey);
            var revealBtn = document.querySelector('.pixel-cat-reveal');
            if (revealBtn) revealBtn.remove();
        }
        function onKey(e) { if (e.key === 'Escape') close(); }

        overlay.addEventListener('click', function (e) { if (e.target === overlay) close(); });
        overlay.querySelector('.pcm-close').addEventListener('click', close);
        document.addEventListener('keydown', onKey);

        document.body.appendChild(overlay);
    }

    function showRevealButton() {
        if (document.querySelector('.pixel-cat-reveal')) return;
        var btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'pixel-cat-reveal';
        btn.innerHTML = '<span class="pcr-emoji">👥</span><span>Nhóm phát triển</span>';
        btn.addEventListener('click', buildTeamModal);
        document.body.appendChild(btn);
    }

    function init() {
        if (document.querySelector('.pixel-cat-trigger')) return;
        var btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'pixel-cat-trigger';
        btn.title = 'Thả mèo pixel chạy ngang màn hình';
        btn.textContent = '🐱';
        btn.addEventListener('click', function () {
            if (catRunning) return;
            catRunning = true;
            btn.setAttribute('disabled', 'disabled');
            spawnCat(function () {
                catRunning = false;
                btn.removeAttribute('disabled');
                showRevealButton();
            });
        });
        document.body.appendChild(btn);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
