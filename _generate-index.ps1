# Regenerates index.html for "Anchors Arcade V67" - game portal + Scramjet web proxy.
# Re-run any time you add/remove game files (run _generate-covers.ps1 first for new covers).
# Placeholders: __GAMES__ (game array), __LOGO_HEADER__ / __LOGO_HERO__ (inlined theme-aware logo.svg)

$ErrorActionPreference = 'Stop'
$dir = $PSScriptRoot
$coversDir = Join-Path $dir 'covers'

$template = @'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="theme-color" content="#07080d">
<title>Anchors Arcade V67</title>
<link rel="icon" type="image/png" href="favicon.png">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap" rel="stylesheet">

<!-- proxy stack -->
<script src="scram/scramjet.all.js"></script>
<script src="baremux/index.js"></script>
<script src="wisp-config.js"></script>
<script src="register-sw.js"></script>
<script src="search.js"></script>

<style>
:root{
  --bg:#07080d; --panel:#12151f; --card:#161b28; --card2:#1c2233;
  --line:#232a3d; --text:#edf0f7; --muted:#8b94a8;
  --gold:#ffc247;
  --pix:'Press Start 2P',monospace;
  /* default theme: black + purple */
  --acc:#a855f7; --acc2:#d8b4fe; --acc-deep:#6b21a8;
  --glow:rgba(168,85,247,.45);
  --glow-soft:rgba(168,85,247,.13);
  --tint:rgba(168,85,247,.17);
  --ring:rgba(168,85,247,.28);
  --ring2:rgba(168,85,247,.45);
  --err:#ff8fae;
}
body[data-theme="red"]{
  --acc:#f8314a; --acc2:#ff6b81; --acc-deep:#c81e39;
  --glow:rgba(248,49,74,.45);
  --glow-soft:rgba(248,49,74,.13);
  --tint:rgba(248,49,74,.18);
  --ring:rgba(248,49,74,.25);
  --ring2:rgba(248,49,74,.4);
  --err:#ff8f9f;
}
*{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth}
body{
  min-height:100vh; background:
    radial-gradient(1000px 560px at 50% -12%, var(--glow-soft), transparent 60%),
    radial-gradient(760px 420px at -10% 34%, rgba(120,90,255,.06), transparent 60%),
    var(--bg);
  color:var(--text);
  font-family:"Segoe UI",system-ui,-apple-system,sans-serif;
}
button{font-family:inherit}
::selection{background:var(--glow)}
:focus-visible{outline:2px solid var(--acc); outline-offset:2px}

/* ---------------- header ---------------- */
#topbar{
  position:sticky; top:0; z-index:40;
  display:flex; align-items:center; gap:16px; flex-wrap:wrap;
  padding:12px 22px;
  background:rgba(7,8,13,.78); backdrop-filter:blur(14px); -webkit-backdrop-filter:blur(14px);
  border-bottom:1px solid var(--line);
}
.brand{display:flex; align-items:center; gap:12px; margin-right:auto; cursor:pointer}
.logo-img{width:40px; height:40px; image-rendering:pixelated; display:block}
.brand .logo-img{filter:drop-shadow(0 4px 14px var(--glow))}
.brand h1{font-size:1.18rem; letter-spacing:.3px; line-height:1.15; white-space:nowrap}
.brand h1 span{color:var(--acc)}
.vchip{
  font-family:var(--pix); font-size:.55rem; color:#fff; letter-spacing:1px;
  background:linear-gradient(135deg,var(--acc),var(--acc-deep)); padding:4px 8px; border-radius:7px;
  box-shadow:0 3px 12px var(--glow); translate:0 -6px;
}
#tagline{font-size:.74rem; color:var(--muted); margin-top:2px}
.nav{display:flex; gap:6px; background:var(--panel); border:1px solid var(--line); border-radius:12px; padding:4px}
.navlink{
  padding:8px 16px; border:none; background:transparent; color:var(--muted);
  font-size:.88rem; font-weight:600; border-radius:9px; cursor:pointer; transition:.15s;
}
.navlink:hover{color:var(--text)}
.navlink.active{background:var(--tint); color:#fff}
.navlink.active::before{content:"\25B6\00a0"; font-size:.7rem; color:var(--acc)}
#settingsBtn{font-size:1.02rem; padding:10px 13px}
#libTools{display:flex; align-items:center; gap:10px; flex-wrap:wrap}
body[data-view="home"] #libTools{display:none}
.searchwrap{position:relative; flex:1 1 220px; max-width:380px}
.searchwrap svg{position:absolute; left:13px; top:50%; translate:0 -50%; width:15px; height:15px; stroke:var(--muted); fill:none; stroke-width:2}
#search{
  width:100%; padding:10px 14px 10px 36px; border-radius:12px;
  border:1px solid var(--line); background:var(--panel); color:var(--text);
  font-size:.92rem; outline:none; transition:border-color .15s;
}
#search:focus{border-color:var(--acc)}
#search::placeholder{color:#5b6478}
select#sort{
  appearance:none; -webkit-appearance:none;
  padding:10px 32px 10px 14px; border-radius:12px; border:1px solid var(--line);
  background:var(--panel) url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="10" height="6" viewBox="0 0 10 6"><path d="M1 1l4 4 4-4" stroke="%238b94a8" stroke-width="1.6" fill="none" stroke-linecap="round"/></svg>') no-repeat right 12px center;
  color:var(--text); font-size:.88rem; cursor:pointer; outline:none;
}
select#sort:focus{border-color:var(--acc)}
.tool{
  padding:10px 14px; border-radius:12px; border:1px solid var(--line);
  background:var(--panel); color:var(--text); cursor:pointer; font-size:.9rem;
  transition:border-color .15s, background .15s, transform .12s; white-space:nowrap;
}
.tool:hover{border-color:#3a445e; background:var(--card2)}
.tool:active{transform:scale(.96)}
.tool.on{border-color:var(--acc); color:#fff; background:var(--tint)}
.tool b{color:var(--acc2)}

/* ---------------- views ---------------- */
.view{display:none}
.view.active{display:block; animation:fadeUp .3s ease}
@keyframes fadeUp{from{opacity:0; transform:translateY(10px)}to{opacity:1; transform:none}}
.wrap{max-width:1280px; margin:0 auto; padding:22px 22px 80px}

/* ---------------- home / hero ---------------- */
#view-home .hero{
  max-width:860px; margin:0 auto; padding:56px 22px 40px;
  display:flex; flex-direction:column; align-items:center; text-align:center;
}
.hero-logo{width:min(200px,42vw); margin-bottom:22px; animation:bob 3.2s ease-in-out infinite}
.hero-logo .logo-img{width:100%; height:auto; filter:drop-shadow(0 10px 34px var(--glow))}
@keyframes bob{0%,100%{transform:translateY(0)}50%{transform:translateY(-8px)}}
.hero h2{
  font-family:var(--pix); font-size:clamp(1rem,3.6vw,1.9rem); line-height:1.5;
  text-shadow:0 0 26px var(--glow); margin-bottom:10px;
}
.hero h2 .thin{color:var(--acc)}
.hero-tag{color:var(--muted); font-size:.98rem; margin-bottom:30px}
.hero-tag b{color:var(--text)}

.psearch{
  display:flex; align-items:center; gap:8px; width:min(620px,100%);
  padding:8px 8px 8px 18px; border-radius:999px;
  background:var(--panel); border:1px solid var(--line);
  transition:border-color .15s, box-shadow .15s;
}
.psearch:focus-within{border-color:var(--acc); box-shadow:0 0 0 4px var(--glow-soft), 0 10px 34px var(--glow-soft)}
.psearch svg{width:18px; height:18px; stroke:var(--muted); fill:none; stroke-width:2; flex:0 0 auto}
#pInput{
  flex:1; min-width:0; background:none; border:none; outline:none;
  color:var(--text); font-size:1rem; padding:10px 0;
}
#pInput::placeholder{color:#5b6478}
.enginesel{
  appearance:none; -webkit-appearance:none; flex:0 0 auto;
  padding:9px 26px 9px 12px; border-radius:999px; border:1px solid var(--line);
  background:var(--card) url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="10" height="6" viewBox="0 0 10 6"><path d="M1 1l4 4 4-4" stroke="%238b94a8" stroke-width="1.6" fill="none" stroke-linecap="round"/></svg>') no-repeat right 10px center;
  color:var(--muted); font-size:.78rem; cursor:pointer; outline:none;
}
.gobtn{
  flex:0 0 auto; width:44px; height:44px; border-radius:50%; border:none; cursor:pointer;
  background:linear-gradient(135deg,var(--acc),var(--acc-deep)); color:#fff; font-size:1.05rem;
  box-shadow:0 6px 20px var(--glow); transition:transform .13s, filter .13s;
}
.gobtn:hover{filter:brightness(1.12); transform:scale(1.06)}
.gobtn:active{transform:scale(.94)}
.gobtn:disabled{opacity:.5; cursor:wait}

.pstatus{min-height:20px; margin-top:14px; font-size:.85rem; color:var(--acc2)}
.bar-track{width:min(420px,80%); height:5px; border-radius:99px; background:var(--panel); overflow:hidden; opacity:0; transition:opacity .2s; margin:8px auto 0}
.bar-track.on{opacity:1}
#pBar{height:100%; width:0%; border-radius:99px; background:linear-gradient(90deg,var(--acc),var(--acc2)); transition:width .3s}
.perror{max-width:560px; margin:10px auto 0; font-size:.85rem; color:var(--err); word-break:break-word}

.chips{display:flex; flex-wrap:wrap; gap:10px; justify-content:center; margin-top:26px}
.chip{
  display:inline-flex; align-items:center; gap:7px;
  padding:9px 16px; border-radius:999px; border:1px solid var(--line);
  background:var(--panel); color:var(--text); font-size:.85rem; cursor:pointer;
  transition:border-color .15s, transform .13s, background .15s;
}
.chip:hover{border-color:var(--acc); background:var(--card2); transform:translateY(-2px)}
.homeCtas{display:flex; gap:12px; flex-wrap:wrap; justify-content:center; margin-top:30px}
.cta{
  display:inline-flex; align-items:center; gap:9px;
  padding:13px 26px; border-radius:14px; border:1px solid var(--line);
  background:var(--panel); color:var(--text); font-size:.95rem; font-weight:700; cursor:pointer;
  transition:border-color .15s, transform .13s, box-shadow .15s;
}
.cta:hover{border-color:var(--acc); transform:translateY(-2px); box-shadow:0 10px 30px var(--glow-soft)}
.cta.red{background:linear-gradient(135deg,var(--acc),var(--acc-deep)); border:none; color:#fff; box-shadow:0 8px 26px var(--glow)}
.cta.red:hover{filter:brightness(1.1)}
.homeStats{display:flex; gap:10px; flex-wrap:wrap; justify-content:center; margin-top:26px}
.stat{
  font-size:.78rem; color:var(--muted); background:rgba(18,21,31,.7);
  border:1px solid var(--line); padding:6px 14px; border-radius:999px;
}
.stat b{color:var(--text)}

.featured{max-width:1280px; margin:34px auto 0; padding:0 22px; width:100%}

/* ---------------- sections / cards ---------------- */
#recentSec{margin-bottom:26px}
.sechead{display:flex; align-items:center; gap:10px; margin-bottom:12px}
.sechead h2{font-size:1rem; font-weight:700; letter-spacing:.3px}
.sechead .accent{color:var(--acc)}
#clearRecent{margin-left:auto; background:none; border:none; color:var(--muted); font-size:.78rem; cursor:pointer; padding:4px 8px; border-radius:8px}
#clearRecent:hover{color:var(--text); background:var(--panel)}
.row{display:flex; gap:14px; overflow-x:auto; padding:4px 2px 10px; scrollbar-width:thin}
.row .game{flex:0 0 150px; width:150px}

.grid{display:grid; gap:16px; grid-template-columns:repeat(auto-fill,minmax(160px,1fr))}
body[data-cards="s"] .grid{grid-template-columns:repeat(auto-fill,minmax(120px,1fr)); gap:12px}
body[data-cards="s"] .row .game{flex-basis:118px; width:118px}
body[data-cards="l"] .grid{grid-template-columns:repeat(auto-fill,minmax(210px,1fr))}
body[data-cards="l"] .row .game{flex-basis:190px; width:190px}
.game{
  position:relative; border-radius:18px; overflow:hidden; cursor:pointer;
  background:var(--card); border:1px solid var(--line);
  opacity:0; translate:0 16px;
  transition:opacity .5s ease, translate .5s ease, transform .16s ease, border-color .16s ease, box-shadow .16s ease;
}
.game.in{opacity:1; translate:0 0}
.game:hover{transform:translateY(-4px); border-color:#39445f; box-shadow:0 16px 38px rgba(0,0,0,.55), 0 0 0 1px var(--ring)}
.thumb{position:relative; aspect-ratio:1/1; overflow:hidden; background:linear-gradient(135deg,#1b2132,#10141f)}
.thumb img{
  position:absolute; inset:0; width:100%; height:100%; object-fit:cover;
  opacity:0; transition:opacity .4s ease, transform .3s ease; z-index:1;
}
.thumb img.ok{opacity:1}
.game:hover .thumb img.ok{transform:scale(1.06)}
.fallback{
  position:absolute; inset:0; display:flex; flex-direction:column; gap:4px;
  align-items:center; justify-content:center; color:#4d5872;
}
.fallback .fe{font-size:2rem}
.fallback .fn{font-weight:800; font-size:1.25rem; color:#68738f}
.play{
  position:absolute; inset:0; z-index:2; display:flex; align-items:center; justify-content:center;
  background:linear-gradient(180deg, rgba(5,7,12,0) 35%, rgba(5,7,12,.78));
  opacity:0; transition:opacity .18s ease;
}
.game:hover .play{opacity:1}
.play span{
  background:var(--acc); color:#fff; font-weight:700; font-size:.85rem;
  padding:9px 18px; border-radius:999px; translate:0 8px; transition:translate .18s ease;
  box-shadow:0 8px 22px var(--glow);
}
.game:hover .play span{translate:0 0}
.meta{display:flex; align-items:center; justify-content:space-between; gap:6px; padding:10px 12px}
.num{font-weight:800; font-size:.95rem}
.suffix{
  font-size:.66rem; color:var(--muted); background:#0d1019;
  border:1px solid var(--line); padding:2px 8px; border-radius:999px;
  overflow:hidden; text-overflow:ellipsis; white-space:nowrap; max-width:70%;
}
.favbtn{
  position:absolute; top:8px; right:8px; z-index:3;
  width:32px; height:32px; border-radius:50%; font-size:.95rem; line-height:1;
  border:1px solid rgba(255,255,255,.15); background:rgba(10,12,18,.55);
  backdrop-filter:blur(6px); color:#c9d1e0; cursor:pointer;
  opacity:0; transition:opacity .15s, color .15s, border-color .15s, transform .12s;
}
.game:hover .favbtn, .favbtn.on{opacity:1}
.favbtn:hover{transform:scale(1.12)}
.favbtn.on{color:var(--gold); border-color:rgba(255,194,71,.55); background:rgba(20,15,5,.6)}

#empty{display:none; text-align:center; color:var(--muted); margin-top:60px; font-size:1.02rem}
#empty b{color:var(--text)}

/* ---------------- game player ---------------- */
#player{position:fixed; inset:0; z-index:100; display:none; flex-direction:column; background:#05070c}
#player.active{display:flex}
.pbar{
  display:flex; align-items:center; gap:8px; flex-wrap:wrap;
  padding:10px 14px; background:rgba(13,16,24,.95);
  border-bottom:1px solid var(--line);
}
.pbar button, .pbar a{
  padding:8px 13px; border-radius:10px; border:1px solid var(--line);
  background:var(--card); color:var(--text); cursor:pointer; font-size:.88rem; text-decoration:none;
  transition:border-color .15s, background .15s, transform .12s; white-space:nowrap;
}
.pbar button:hover, .pbar a:hover{border-color:#3a445e; background:var(--card2)}
.pbar button:active{transform:scale(.95)}
.pbar button:disabled{opacity:.32; cursor:default}
.pbar button:disabled:hover{border-color:var(--line); background:var(--card)}
#pTitle{flex:1 1 140px; text-align:center; font-weight:700; min-width:100px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis}
#pTitle .suffix{font-size:.68rem; font-weight:400; margin-left:6px}
#favBtn.on{color:var(--gold); border-color:rgba(255,194,71,.55)}
#frame{flex:1; width:100%; border:0; background:#000}

/* ---------------- proxy browser ---------------- */
#browse{position:fixed; inset:0; z-index:90; display:none; flex-direction:column; background:#0b0d13}
#browse.active{display:flex}
.bbar{
  display:flex; align-items:center; gap:7px; flex-wrap:wrap;
  padding:9px 12px; background:rgba(13,16,24,.97); border-bottom:1px solid var(--line);
}
.bbar button{
  width:38px; height:38px; border-radius:10px; border:1px solid var(--line);
  background:var(--card); color:var(--text); cursor:pointer; font-size:.95rem;
  transition:border-color .15s, background .15s, transform .12s; flex:0 0 auto;
}
.bbar button:hover{border-color:#3a445e; background:var(--card2)}
.bbar button:active{transform:scale(.93)}
.baddrwrap{
  flex:1 1 220px; display:flex; align-items:center; gap:8px; min-width:160px;
  background:var(--panel); border:1px solid var(--line); border-radius:999px; padding:4px 6px 4px 16px;
}
.baddrwrap:focus-within{border-color:var(--acc)}
.baddrwrap .lock{font-size:.75rem; opacity:.75}
#bAddr{flex:1; min-width:0; background:none; border:none; outline:none; color:var(--text); font-size:.9rem; padding:7px 0}
#bGo{width:auto !important; padding:0 16px !important; border-radius:999px !important; font-size:.82rem !important; font-weight:700; background:var(--tint); border-color:var(--ring2) !important}
#bFrameWrap{flex:1; position:relative; background:#fff}
#bFrameWrap iframe{position:absolute; inset:0; width:100%; height:100%; border:0; background:#fff}

/* ---------------- settings modal ---------------- */
#settingsModal{position:fixed; inset:0; z-index:150; display:none; align-items:center; justify-content:center; padding:20px}
#settingsModal.active{display:flex}
.sback{position:absolute; inset:0; background:rgba(4,6,10,.72); backdrop-filter:blur(6px); -webkit-backdrop-filter:blur(6px)}
.spanel{
  position:relative; width:min(560px,100%); max-height:min(86vh,720px);
  display:flex; flex-direction:column;
  background:var(--panel); border:1px solid var(--line); border-radius:18px;
  box-shadow:0 30px 80px rgba(0,0,0,.6), 0 0 0 1px var(--ring);
  animation:pop .22s ease;
}
@keyframes pop{from{opacity:0; transform:scale(.96) translateY(8px)}to{opacity:1; transform:none}}
.shead{display:flex; align-items:center; justify-content:space-between; padding:16px 20px; border-bottom:1px solid var(--line)}
.shead h2{font-size:1.05rem}
.shead h2 .accent{color:var(--acc)}
#sClose{
  width:34px; height:34px; border-radius:10px; border:1px solid var(--line);
  background:var(--card); color:var(--text); cursor:pointer; font-size:.9rem;
}
#sClose:hover{border-color:var(--err); color:var(--err)}
.sbody{overflow-y:auto; padding:4px 20px 20px}
.ssec{padding:16px 0; border-bottom:1px solid var(--line)}
.ssec:last-child{border-bottom:none; padding-bottom:6px}
.ssec h3{font-size:.72rem; letter-spacing:1.5px; text-transform:uppercase; color:var(--muted); margin-bottom:12px}
.srow{display:flex; align-items:center; justify-content:space-between; gap:14px; padding:7px 0}
.srow .lab{font-size:.92rem}
.srow .sub{display:block; font-size:.76rem; color:var(--muted); margin-top:2px; font-weight:400}
.sbody select{
  appearance:none; -webkit-appearance:none;
  padding:9px 30px 9px 12px; border-radius:10px; border:1px solid var(--line);
  background:var(--card) url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="10" height="6" viewBox="0 0 10 6"><path d="M1 1l4 4 4-4" stroke="%238b94a8" stroke-width="1.6" fill="none" stroke-linecap="round"/></svg>') no-repeat right 10px center;
  color:var(--text); font-size:.86rem; cursor:pointer; outline:none;
}
.sbody select:focus{border-color:var(--acc)}
.swatches{display:flex; gap:10px; flex-wrap:wrap}
.swatch{
  display:flex; align-items:center; gap:9px; padding:10px 14px; border-radius:12px;
  border:1px solid var(--line); background:var(--card); color:var(--text);
  cursor:pointer; font-size:.88rem; transition:border-color .15s, box-shadow .15s;
}
.swatch:hover{border-color:#3a445e}
.swatch .dot{width:18px; height:18px; border-radius:6px; flex:0 0 auto}
.swatch[data-t="purple"] .dot{background:linear-gradient(135deg,#a855f7,#6b21a8)}
.swatch[data-t="red"] .dot{background:linear-gradient(135deg,#f8314a,#c81e39)}
.swatch.on{border-color:var(--acc); box-shadow:0 0 0 3px var(--tint)}
.tgl{
  position:relative; width:46px; height:25px; border-radius:99px; flex:0 0 auto;
  background:var(--card2); border:1px solid var(--line); cursor:pointer; transition:.18s;
}
.tgl::after{content:""; position:absolute; top:2px; left:2px; width:19px; height:19px; border-radius:50%; background:var(--muted); transition:.18s}
.tgl.on{background:var(--acc); border-color:var(--acc)}
.tgl.on::after{left:23px; background:#fff}
.wrow{display:flex; gap:8px; width:100%}
.wrow input{
  flex:1; min-width:0; padding:9px 12px; border-radius:10px; border:1px solid var(--line);
  background:var(--card); color:var(--text); font-size:.86rem; outline:none;
}
.wrow input:focus{border-color:var(--acc)}
.wout{display:block; min-height:18px; font-size:.8rem; color:var(--muted); margin-top:8px; word-break:break-all}
.wout.good{color:#7ce38b}
.wout.bad{color:var(--err)}
.sbtn{
  padding:9px 14px; border-radius:10px; border:1px solid var(--line);
  background:var(--card); color:var(--text); font-size:.85rem; cursor:pointer;
  transition:border-color .15s, background .15s, transform .12s;
}
.sbtn:hover{border-color:#3a445e; background:var(--card2)}
.sbtn:active{transform:scale(.97)}
.sbtn.danger{color:var(--err); border-color:rgba(255,90,110,.35)}
.sbtn.danger:hover{background:rgba(255,90,110,.08); border-color:var(--err)}
.sbtnrow{display:flex; gap:8px; flex-wrap:wrap}
.about{font-size:.85rem; color:var(--muted); line-height:1.85}
.about a{color:var(--acc2); text-decoration:none}
.about a:hover{text-decoration:underline}
.about b{color:var(--text)}

/* ---------------- misc ---------------- */
footer{
  border-top:1px solid var(--line); padding:26px 22px 30px; text-align:center;
  color:var(--muted); font-size:.8rem; line-height:1.9;
}
footer a{color:var(--acc2); text-decoration:none}
footer a:hover{text-decoration:underline}
#toTop{
  position:fixed; right:22px; bottom:22px; z-index:60;
  width:44px; height:44px; border-radius:50%; border:1px solid var(--line);
  background:var(--panel); color:var(--text); font-size:1.1rem; cursor:pointer;
  opacity:0; pointer-events:none; transition:opacity .2s, border-color .15s;
}
#toTop.show{opacity:1; pointer-events:auto}
#toTop:hover{border-color:var(--acc)}
#toast{
  position:fixed; left:50%; bottom:26px; translate:-50% 16px; z-index:200;
  padding:10px 18px; border-radius:12px; border:1px solid var(--line);
  background:rgba(18,21,31,.95); color:var(--text); font-size:.88rem;
  opacity:0; pointer-events:none; transition:opacity .2s, translate .2s;
}
#toast.show{opacity:1; translate:-50% 0}
::-webkit-scrollbar{width:10px; height:10px}
::-webkit-scrollbar-thumb{background:#252d42; border-radius:8px}
::-webkit-scrollbar-thumb:hover{background:#303a55}
::-webkit-scrollbar-track{background:transparent}
body.no-anim *, body.no-anim *::before, body.no-anim *::after{animation:none !important; transition:none !important}
@media (prefers-reduced-motion: reduce){
  *{animation:none !important; transition:none !important}
}
</style>
</head>
<body data-view="home">

<header id="topbar">
  <div class="brand" id="brandHome" title="Anchors Arcade V67 - Home">
    __LOGO_HEADER__
    <div class="brandtext">
      <h1>Anchors <span>Arcade</span></h1>
      <p id="tagline"></p>
    </div>
    <span class="vchip">V67</span>
  </div>
  <nav class="nav" aria-label="Sections">
    <button class="navlink active" data-nav="home">Home</button>
    <button class="navlink" data-nav="library">Library</button>
  </nav>
  <button id="settingsBtn" class="tool" title="Settings">&#9881;&#65039;</button>
  <div class="tools" id="libTools">
    <div class="searchwrap">
      <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="M20 20l-3.5-3.5"/></svg>
      <input id="search" type="search" placeholder="Search games&#8230;" autocomplete="off">
    </div>
    <select id="sort" title="Sort games">
      <option value="new">Newest first</option>
      <option value="old">Oldest first</option>
      <option value="az">A &#8594; Z</option>
      <option value="za">Z &#8594; A</option>
      <option value="rnd">Shuffle</option>
    </select>
    <button id="favToggle" class="tool" title="Show favorites only">&#9829; <b id="favCount">0</b></button>
    <button id="randomBtn" class="tool" title="Play a random game">&#127922;</button>
  </div>
</header>

<main>
  <!-- ============ HOME (greeting + proxy) ============ -->
  <section id="view-home" class="view active">
    <div class="hero">
      <div class="hero-logo">__LOGO_HERO__</div>
      <h2>ANCHORS <span class="thin">ARCADE</span></h2>
      <p class="hero-tag">Play <b id="heroCount">&#8230;</b> games, or surf the web &#8212; unblocked.</p>

      <form id="pForm" style="width:100%;display:flex;justify-content:center">
        <div class="psearch">
          <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="M20 20l-3.5-3.5"/></svg>
          <input id="pInput" type="text" placeholder="Search the web or enter a URL" autocomplete="off" spellcheck="false">
          <select id="pEngine" class="enginesel" title="Search engine">
            <option value="https://html.duckduckgo.com/html/?q=%s">DuckDuckGo</option>
            <option value="https://search.brave.com/search?q=%s">Brave</option>
            <option value="https://www.bing.com/search?q=%s">Bing</option>
            <option value="https://www.mojeek.com/search?q=%s">Mojeek</option>
          </select>
          <button id="pGo" type="submit" class="gobtn" title="Go">&#8599;</button>
        </div>
      </form>

      <div id="pStatus" class="pstatus" aria-live="polite"></div>
      <div class="bar-track" id="pBarTrack"><div id="pBar"></div></div>
      <p id="pError" class="perror"></p>

      <div class="chips">
        <button type="button" class="chip" data-url="https://www.youtube.com">&#9654;&#65039; YouTube</button>
        <button type="button" class="chip" data-url="https://www.tiktok.com">&#127925; TikTok</button>
        <button type="button" class="chip" data-url="https://www.instagram.com">&#128247; Instagram</button>
        <button type="button" class="chip" data-url="https://discord.com">&#127918; Discord</button>
        <button type="button" class="chip" data-url="https://www.reddit.com">&#128126; Reddit</button>
        <button type="button" class="chip" data-url="https://www.wikipedia.org">&#128218; Wikipedia</button>
      </div>

      <div class="homeCtas">
        <button id="enterLib" class="cta red">&#127918; Enter the Library</button>
      </div>

      <div class="homeStats">
        <span class="stat"><b id="statGames">0</b> games</span>
        <span class="stat"><b id="statCovers">0</b> with covers</span>
        <span class="stat"><b id="statFavs">0</b> favorites</span>
        <span class="stat">proxy: <b>Scramjet</b></span>
      </div>
    </div>

    <div class="featured">
      <div class="sechead"><h2><span class="accent">&#9733;</span> Featured games</h2></div>
      <div id="featRow" class="row"></div>
    </div>
  </section>

  <!-- ============ LIBRARY ============ -->
  <section id="view-library" class="view">
    <div class="wrap">
      <section id="recentSec" hidden>
        <div class="sechead">
          <h2><span class="accent">&#9654;</span> Continue playing</h2>
          <button id="clearRecent">Clear</button>
        </div>
        <div id="recentRow" class="row"></div>
      </section>
      <div id="grid" class="grid"></div>
      <p id="empty"></p>
    </div>
  </section>
</main>

<!-- ============ PROXY BROWSER ============ -->
<div id="browse">
  <div class="bbar">
    <button id="bBack" title="Back">&#8592;</button>
    <button id="bFwd" title="Forward">&#8594;</button>
    <button id="bReload" title="Reload">&#10227;</button>
    <button id="bHome" title="Anchors Arcade home">&#9875;</button>
    <form id="bForm" class="baddrwrap">
      <span class="lock">&#128274;</span>
      <input id="bAddr" type="text" placeholder="Search or enter address" autocomplete="off" spellcheck="false">
      <button id="bGo" type="submit">Go</button>
    </form>
    <button id="bNew" title="Open for real (without proxy)">&#8599;</button>
    <button id="bFs" title="Fullscreen">&#9974;</button>
    <button id="bExit" title="Close browser (Esc)">&#10005;</button>
  </div>
  <div id="bFrameWrap"></div>
</div>

<!-- ============ GAME PLAYER ============ -->
<div id="player">
  <div class="pbar">
    <button id="backBtn">&#8592; Library</button>
    <button id="prevBtn" title="Previous (left arrow)">&#8249;</button>
    <div id="pTitle"></div>
    <button id="nextBtn" title="Next (right arrow)">&#8250;</button>
    <span style="flex:1"></span>
    <button id="favBtn" title="Toggle favorite (star)">&#9734;</button>
    <button id="fsBtn" title="Fullscreen (F)">&#9974;</button>
    <a id="newTabBtn" href="#" target="_blank" title="Open in new tab">&#8599;</a>
    <button id="copyBtn" title="Copy link to this game">&#8904;</button>
    <button id="closeBtn" title="Close (Esc)">&#10005;</button>
  </div>
  <iframe id="frame" allow="fullscreen; autoplay; gamepad; pointer-lock; clipboard-write"></iframe>
</div>

<!-- ============ SETTINGS ============ -->
<div id="settingsModal" role="dialog" aria-modal="true" aria-label="Settings">
  <div class="sback"></div>
  <div class="spanel">
    <div class="shead">
      <h2><span class="accent">&#9881;</span> Settings</h2>
      <button id="sClose" title="Close (Esc)">&#10005;</button>
    </div>
    <div class="sbody">
      <section class="ssec">
        <h3>Theme</h3>
        <div class="swatches">
          <button type="button" class="swatch" data-t="purple"><span class="dot"></span>Purple</button>
          <button type="button" class="swatch" data-t="red"><span class="dot"></span>Red</button>
        </div>
      </section>
      <section class="ssec">
        <h3>Library</h3>
        <div class="srow">
          <span class="lab">Card size</span>
          <select id="sCards">
            <option value="s">Small</option>
            <option value="m">Medium</option>
            <option value="l">Large</option>
          </select>
        </div>
        <div class="srow">
          <span class="lab">Animations <span class="sub">Hover effects, fades and the floating logo</span></span>
          <button id="sAnim" class="tgl" type="button" aria-label="Toggle animations"></button>
        </div>
        <div class="srow">
          <span class="lab">Open on <span class="sub">Which page the site starts on</span></span>
          <select id="sLanding">
            <option value="home">Home</option>
            <option value="library">Library</option>
          </select>
        </div>
      </section>
      <section class="ssec">
        <h3>Proxy</h3>
        <div class="srow">
          <span class="lab">Search engine</span>
          <select id="sEngine">
            <option value="https://html.duckduckgo.com/html/?q=%s">DuckDuckGo</option>
            <option value="https://search.brave.com/search?q=%s">Brave</option>
            <option value="https://www.bing.com/search?q=%s">Bing</option>
            <option value="https://www.mojeek.com/search?q=%s">Mojeek</option>
          </select>
        </div>
        <div class="srow" style="flex-direction:column;align-items:stretch;gap:8px">
          <span class="lab">Wisp server <span class="sub">Leave empty to use the built-in server</span></span>
          <div class="wrow">
            <input id="wispInput" type="text" placeholder="wss://your-server.example/wisp/" spellcheck="false" autocomplete="off">
            <button id="wispTest" class="sbtn" type="button">Test</button>
          </div>
          <span id="wispNow" class="wout"></span>
          <span id="wispTestOut" class="wout"></span>
        </div>
      </section>
      <section class="ssec">
        <h3>Data</h3>
        <div class="sbtnrow">
          <button id="sClearRecent" class="sbtn" type="button">Clear recently played</button>
          <button id="sClearFavs" class="sbtn" type="button">Clear favorites</button>
          <button id="sReset" class="sbtn danger" type="button">Reset everything</button>
        </div>
      </section>
      <section class="ssec">
        <h3>About</h3>
        <p class="about">
          &#9875; <b>Anchors Arcade V67</b> &#8212; <span id="sCount"></span> games and an unblocked browser, all in one place.<br>
          Shortcuts: <b>/</b> search &#183; <b>Esc</b> close &#183; <b>&#8592;/&#8594;</b> switch game &#183; <b>F</b> fullscreen.<br>
          Proxy powered by <a href="https://github.com/MercuryWorkshop/scramjet" target="_blank" rel="noopener">Scramjet</a> (Mercury Workshop).
        </p>
      </section>
    </div>
  </div>
</div>

<footer>
  <div>&#9875; Anchors Arcade <b>V67</b> &#8212; <span id="footCount"></span> games aboard</div>
  <div>Proxy powered by <a href="https://github.com/MercuryWorkshop/scramjet" target="_blank" rel="noopener">Scramjet</a> (Mercury Workshop) &#183; covers &#38; games &#169; their respective owners</div>
</footer>

<button id="toTop" title="Back to top">&#8593;</button>
<div id="toast"></div>

<script>
"use strict";

/* ============================== DATA ============================== */
const GAMES = __GAMES__;

/* stable numeric order, used for prev/next navigation */
const NAV = GAMES.slice().sort((a,b)=> a.n-b.n || a.f.localeCompare(b.f,undefined,{numeric:true}));
const byFile = new Map(GAMES.map(g=>[g.f,g]));

/* ============================== STORAGE ============================== */
const store = {
  get(k,d){ try{ const v=localStorage.getItem(k); return v===null?d:JSON.parse(v); }catch(e){ return d; } },
  set(k,v){ try{ localStorage.setItem(k,JSON.stringify(v)); }catch(e){} }
};
let favs   = new Set(store.get("gn_favs", []));
let recent = store.get("gn_recent", []).filter(f=>byFile.has(f));

/* ============================== SETTINGS ============================== */
const DEFAULT_WISP = (typeof WISP_URL==="string" && WISP_URL) ? WISP_URL : "wss://anchors-arcade-proxeyy.onrender.com/wisp/";
const settings={
  theme:   store.get("gn_theme","purple"),
  cards:   store.get("gn_cards","m"),
  anim:    store.get("gn_anim",true),
  landing: store.get("gn_landing","home"),
  wisp:    store.get("aa_wisp",""),
};
if(!["purple","red"].includes(settings.theme)) settings.theme="purple";
if(!["s","m","l"].includes(settings.cards)) settings.cards="m";
if(!["home","library"].includes(settings.landing)) settings.landing="home";

/* effective wisp server: user override or built-in */
function effWisp(){ const w=(settings.wisp||"").trim(); return w||DEFAULT_WISP; }
let activeWisp=effWisp();

function applySettings(){
  document.body.dataset.theme=settings.theme;
  document.body.dataset.cards=settings.cards;
  document.body.classList.toggle("no-anim",!settings.anim);
}

/* ============================== STATE ============================== */
let sort = store.get("gn_sort", "new");
let favsOnly = false;
let query = "";
if(!["new","old","az","za","rnd"].includes(sort)) sort = "new";

const $ = id => document.getElementById(id);
const grid=$("grid"), searchBox=$("search"), frame=$("frame");

const EMOJI=["\uD83C\uDFAE","\uD83D\uDC7E","\uD83D\uDD79\uFE0F","\uD83C\uDFB2","\uD83D\uDE80","\u2B50","\uD83D\uDD25","\uD83C\uDFAF","\uD83C\uDFC6","\u26A1","\uD83E\uDDE9","\u2693"];
const emojiFor=n=>{let h=0;for(const c of n)h=(h*31+c.charCodeAt(0))>>>0;return EMOJI[h%EMOJI.length];};

/* ============================== CARD FACTORY ============================== */
const io = new IntersectionObserver(es=>{
  for(const e of es) if(e.isIntersecting){ e.target.classList.add("in"); io.unobserve(e.target); }
},{rootMargin:"200px"});

function makeCard(g){
  const el=document.createElement("div");
  el.className="game";
  el.dataset.f=g.f;
  el.title="#"+g.n+(g.s?" \u00B7 "+g.s:"")+"\u2014 click to play";
  el.innerHTML =
    '<div class="thumb">'+
      (g.c?'<img loading="lazy" decoding="async" src="'+g.c+'" alt="">':'')+
      '<div class="fallback"><span class="fe">'+emojiFor(g.f)+'</span><span class="fn">#'+g.n+'</span></div>'+
      '<div class="play"><span>\u25B6 Play</span></div>'+
    '</div>'+
    '<div class="meta"><span class="num">#'+g.n+'</span>'+
      (g.s?'<span class="suffix">'+g.s+'</span>':'')+
    '</div>'+
    '<button class="favbtn'+(favs.has(g.f)?" on":"")+'" title="Toggle favorite">\u2605</button>';

  const img=el.querySelector("img");
  if(img){
    img.addEventListener("load", ()=>img.classList.add("ok"));
    img.addEventListener("error", ()=>img.remove());
  }
  el.addEventListener("click", ()=>openGame(g.f));
  el.querySelector(".favbtn").addEventListener("click", e=>{ e.stopPropagation(); toggleFav(g.f); });
  io.observe(el);
  return el;
}

/* one card node per game, reused across renders */
const cardCache=new Map();
for(const g of GAMES) cardCache.set(g.f, makeCard(g));

/* ============================== RENDERING ============================== */
const CMP={
  new:(a,b)=> b.n-a.n || a.f.localeCompare(b.f,undefined,{numeric:true}),
  old:(a,b)=> a.n-b.n || a.f.localeCompare(b.f,undefined,{numeric:true}),
  az: (a,b)=> a.f.localeCompare(b.f,undefined,{numeric:true}),
  za: (a,b)=> b.f.localeCompare(a.f,undefined,{numeric:true}),
  rnd:(a,b)=> a.r-b.r
};

function currentList(){
  let list=GAMES;
  if(favsOnly) list=list.filter(g=>favs.has(g.f));
  const q=query.trim().toLowerCase();
  if(q) list=list.filter(g=> g.f.toLowerCase().includes(q) || String(g.n).includes(q.replace(/^#/,"")) || g.s.toLowerCase().includes(q));
  return list.slice().sort(CMP[sort]||CMP.old);
}

function renderGrid(){
  const list=currentList();
  const frag=document.createDocumentFragment();
  for(const g of list) frag.appendChild(cardCache.get(g.f));
  grid.replaceChildren(frag);
  const empty=$("empty");
  if(list.length===0){
    empty.style.display="block";
    empty.innerHTML = favsOnly
      ? "No favorites yet.<br>Press the <b>\u2605</b> on any game to add it here."
      : "No games match <b>"+query.replace(/[<>&]/g,"")+"</b>.<br>Games are numbered &#8212; try a number like <b>842</b>.";
  }else empty.style.display="none";
}

function renderRecent(){
  const sec=$("recentSec"), row=$("recentRow");
  if(recent.length===0){ sec.hidden=true; return; }
  sec.hidden=false;
  const frag=document.createDocumentFragment();
  for(const f of recent){ const g=byFile.get(f); if(g) frag.appendChild(makeCard(g)); }
  row.replaceChildren(frag);
}

function renderFeatured(){
  const frag=document.createDocumentFragment();
  const picks=[...GAMES].sort(()=>Math.random()-0.5).slice(0,8);
  for(const g of picks) frag.appendChild(makeCard(g));
  $("featRow").replaceChildren(frag);
}

function renderFavCount(){
  $("favCount").textContent=favs.size;
  $("statFavs").textContent=favs.size;
}

/* ============================== FAVORITES / RECENT ============================== */
function toggleFav(f){
  if(favs.has(f)){ favs.delete(f); toast("Removed from favorites"); }
  else{ favs.add(f); toast("Added to favorites \u2605"); }
  store.set("gn_favs",[...favs]);
  renderFavCount();
  document.querySelectorAll('.game[data-f]').forEach(el=>{
    if(el.dataset.f!==f) return;
    const b=el.querySelector(".favbtn");
    if(b) b.classList.toggle("on", favs.has(f));
  });
  if($("player").classList.contains("active")) syncPlayerFavBtn();
  if(favsOnly) renderGrid();
}

function addRecent(f){
  recent=[f, ...recent.filter(x=>x!==f)].slice(0,12);
  store.set("gn_recent",recent);
  renderRecent();
}

$("clearRecent").addEventListener("click",()=>{ recent=[]; store.set("gn_recent",recent); renderRecent(); });

/* ============================== VIEWS / ROUTING ============================== */
function showView(v){
  document.body.dataset.view=v;
  for(const el of document.querySelectorAll(".view")) el.classList.toggle("active", el.id==="view-"+v);
  for(const b of document.querySelectorAll(".navlink")) b.classList.toggle("active", b.dataset.nav===v);
  if(v==="library") renderGrid();
}

/* route(initial): the landing-page setting only applies to the very first load */
function route(initial){
  const m=location.hash.match(/^#p=(.+)$/);
  const f=m?decodeURIComponent(m[1]):null;
  let v;
  if(f||location.hash==="#library") v="library";
  else if(initial) v=settings.landing==="library" ? "library" : "home";
  else v="home";
  showView(v);
  if(f&&byFile.has(f)) showPlayer(byFile.get(f));
  else closePlayer();
}
window.addEventListener("hashchange",()=>route(false));

function goHome(){
  hideBrowse();
  if(location.hash===""||location.hash==="#") showView("home");
  else location.hash="";
}

document.querySelectorAll(".navlink").forEach(b=>b.addEventListener("click",()=>{
  if(b.dataset.nav==="library") location.hash="#library";
  else goHome();
}));
$("brandHome").addEventListener("click",goHome);
$("enterLib").addEventListener("click",()=>{ location.hash="#library"; });

/* ============================== GAME PLAYER ============================== */
let current=null;

function openGame(f){ location.hash="p="+f; }

function showPlayer(g){
  current=g;
  frame.src=g.f;
  $("pTitle").innerHTML="#"+g.n+(g.s?'<span class="suffix">'+g.s+"</span>":"");
  $("newTabBtn").href=g.f;
  syncPlayerFavBtn();
  const i=NAV.indexOf(g);
  $("prevBtn").disabled=i<=0;
  $("nextBtn").disabled=i<0||i>=NAV.length-1;
  $("player").classList.add("active");
  document.body.style.overflow="hidden";
  document.title="\u25B6 #"+g.n+" \u00B7 Anchors Arcade";
  addRecent(g.f);
}

function closePlayer(){
  current=null;
  $("player").classList.remove("active");
  frame.src="about:blank";
  document.body.style.overflow="";
  document.title="Anchors Arcade V67";
}

function syncPlayerFavBtn(){
  const b=$("favBtn");
  b.innerHTML=favs.has(current.f)?"\u2605":"\u2606";
  b.classList.toggle("on", favs.has(current.f));
}

function step(d){
  if(!current) return;
  const i=NAV.indexOf(current), j=i+d;
  if(j>=0&&j<NAV.length) location.hash="p="+NAV[j].f;
}

$("backBtn").addEventListener("click",()=>{ location.hash=""; });
$("closeBtn").addEventListener("click",()=>{ location.hash=""; });
$("prevBtn").addEventListener("click",()=>step(-1));
$("nextBtn").addEventListener("click",()=>step(1));
$("favBtn").addEventListener("click",()=>toggleFav(current.f));
$("fsBtn").addEventListener("click",toggleFullscreen);
$("copyBtn").addEventListener("click",()=>copyLink(current.f));

function toggleFullscreen(){
  if(document.fullscreenElement) document.exitFullscreen();
  else if(frame.requestFullscreen) frame.requestFullscreen();
}

function copyLink(f){
  const url=location.href.split("#")[0]+"#p="+f;
  const done=()=>toast("Link copied to clipboard");
  const fallback=()=>{
    try{
      const t=document.createElement("textarea");
      t.value=url; t.style.position="fixed"; t.style.opacity="0";
      document.body.appendChild(t); t.select();
      document.execCommand("copy"); t.remove(); done();
    }catch(e){ toast("Could not copy link"); }
  };
  if(navigator.clipboard&&navigator.clipboard.writeText)
    navigator.clipboard.writeText(url).then(done).catch(fallback);
  else fallback();
}

/* ============================== PROXY (Scramjet + wisp) ============================== */
let sj=null, sjConn=null, sjBootPromise=null, sjFrameMod=null;
let browsePrevView="home", browseCurrent="";

const abs=p=>new URL(p,location.href).toString();
const setStatus=t=>{ $("pStatus").textContent=t||""; };
const setProg=p=>{ $("pBarTrack").classList.toggle("on",p>0); $("pBar").style.width=p+"%"; };
function proxyError(msg, err){
  $("pError").textContent=msg||"";
  if(err) console.error(err);
  setStatus(""); setProg(0);
}
const isFile=()=>location.protocol==="file:";

/* search engine preference (shared with Settings) */
const engineSel=$("pEngine");
try{
  const saved=localStorage.getItem("aa_engine");
  if(saved && [...engineSel.options].some(o=>o.value===saved)) engineSel.value=saved;
  engineSel.addEventListener("change",()=>localStorage.setItem("aa_engine",engineSel.value));
}catch(e){}

async function waitForWisp(url,maxMs){
  const start=Date.now(); let tries=0;
  while(Date.now()-start<maxMs){
    tries++;
    const ok=await new Promise(resolve=>{
      let ws, done=false;
      const finish=v=>{ if(!done){ done=true; try{ws.close();}catch(e){} resolve(v); } };
      try{ ws=new WebSocket(url); }catch(e){ return resolve(false); }
      ws.onopen=()=>finish(true);
      ws.onerror=()=>finish(false);
      ws.onclose=()=>finish(false);
      setTimeout(()=>finish(false),8000);
    });
    if(ok) return true;
    setStatus("Waking up the server\u2026 (attempt "+tries+")");
    setProg(Math.min(35+tries*4,70));
    await new Promise(r=>setTimeout(r,3000));
  }
  return false;
}

async function ensureProxy(){
  if(sjBootPromise) return sjBootPromise;
  sjBootPromise=(async()=>{
    if(isFile()) throw new Error("The proxy needs the site to be hosted (https) or run from a local web server. Games work fine offline \u2014 host this folder to unlock browsing.");
    if(!navigator.serviceWorker) throw new Error("This browser does not support service workers (required by the proxy).");
    setStatus("Loading proxy core\u2026"); setProg(15);
    if(!sj){
      const { ScramjetController }=$scramjetLoadController();
      sj=new ScramjetController({files:{
        wasm:abs("scram/engine.txt"),
        all:abs("scram/scramjet.all.js"),
        sync:abs("scram/scramjet.sync.js"),
      }});
    }
    try{ await sj.init(); }
    catch(e){
      setStatus("Repairing proxy data\u2026");
      try{ for(const r of await navigator.serviceWorker.getRegistrations()) await r.unregister(); }catch(_){}
      await new Promise(res=>{ const rq=indexedDB.deleteDatabase("$scramjet"); rq.onsuccess=rq.onerror=rq.onblocked=()=>res(); setTimeout(res,3000); });
      await sj.init();
    }
    setProg(35); setStatus("Registering service worker\u2026");
    await registerSW();
    await navigator.serviceWorker.ready;
    setProg(55); setStatus("Connecting to the server\u2026");
    const w=effWisp();
    if(!w) throw new Error("No wisp server configured \u2014 set one in Settings \u2699.");
    if(!(await waitForWisp(w,45000)))
      throw new Error("Could not reach the proxy server. It may be asleep or offline \u2014 try again in a minute.");
    setProg(80); setStatus("Setting up transport\u2026");
    sjConn=sjConn||new BareMux.BareMuxConnection(abs("baremux/worker.js"));
    const cur=await sjConn.getTransport();
    const transportOk = cur===abs("libcurl/index.mjs") || String(cur).startsWith("blob:");
    if(!transportOk || activeWisp!==w){
      try{ await sjConn.setTransport(abs("libcurl/index.mjs"),[{websocket:w}]); }
      catch(err){
        const src=await (await fetch(abs("libcurl/index.mjs"))).text();
        if(!src.includes("LibcurlClient")) throw err;
        await sjConn.setTransport(URL.createObjectURL(new Blob([src],{type:"text/javascript"})),[{websocket:w}]);
      }
      activeWisp=w;
    }
    setProg(100); setStatus("");
    setTimeout(()=>setProg(0),400);
    return sj;
  })().catch(e=>{ sjBootPromise=null; setProg(0); setStatus(""); throw e; });
  return sjBootPromise;
}

function ensureBrowseFrame(){
  if(sjFrameMod) return sjFrameMod;
  sjFrameMod=sj.createFrame();
  sjFrameMod.frame.id="sjFrame";
  $("bFrameWrap").appendChild(sjFrameMod.frame);
  try{
    sjFrameMod.addEventListener("urlchange",e=>{ $("bAddr").value=String(e.url); browseCurrent=String(e.url); });
  }catch(e){}
  return sjFrameMod;
}

function showBrowse(url){
  closePlayer();
  browseCurrent=url;
  document.body.style.overflow="hidden";
  $("browse").classList.add("active");
  $("bAddr").value=url;
  const mod=ensureBrowseFrame();
  mod.frame.style.display="";
  try{ mod.go(url); }catch(e){}
}

function hideBrowse(){
  $("browse").classList.remove("active");
  if(sjFrameMod) sjFrameMod.frame.style.display="none";
  document.body.style.overflow="";
}

async function browseTo(input){
  const q=(input||"").trim();
  if(!q) return;
  $("pError").textContent="";
  const btn=$("pGo"); btn.disabled=true;
  try{
    setStatus("Booting proxy\u2026"); setProg(8);
    await ensureProxy();
    setStatus(""); setProg(0);
    browsePrevView=document.body.dataset.view==="library"?"library":"home";
    showBrowse(search(q,engineSel.value));
    toast("Proxy connected \u2693");
  }catch(err){
    proxyError(err.message||"The proxy failed to start.", err);
  }finally{
    btn.disabled=false;
  }
}

$("pForm").addEventListener("submit",e=>{ e.preventDefault(); browseTo($("pInput").value); });
document.querySelectorAll(".chip").forEach(c=>c.addEventListener("click",()=>browseTo(c.dataset.url)));

$("bBack").addEventListener("click",()=>{ try{ sjFrameMod.back(); }catch(e){} });
$("bFwd").addEventListener("click",()=>{ try{ sjFrameMod.forward(); }catch(e){} });
$("bReload").addEventListener("click",()=>{ try{ sjFrameMod.reload(); }catch(e){} });
$("bHome").addEventListener("click",()=>{ hideBrowse(); goHome(); });
$("bExit").addEventListener("click",()=>{ hideBrowse(); showView(browsePrevView); });
$("bNew").addEventListener("click",()=>{ if(browseCurrent) window.open(browseCurrent,"_blank"); });
$("bFs").addEventListener("click",()=>{
  const el=$("browse");
  if(document.fullscreenElement) document.exitFullscreen();
  else if(el.requestFullscreen) el.requestFullscreen();
});
$("bForm").addEventListener("submit",e=>{
  e.preventDefault();
  const q=$("bAddr").value.trim();
  if(q&&sjFrameMod){ try{ sjFrameMod.go(search(q,engineSel.value)); }catch(err){} }
});

/* ============================== SETTINGS UI ============================== */
const settingsModal=$("settingsModal");

function openSettings(){
  settingsModal.classList.add("active");
  syncSettingsUI();
  document.body.style.overflow="hidden";
}
function closeSettings(){
  settingsModal.classList.remove("active");
  document.body.style.overflow="";
}
function syncSettingsUI(){
  document.querySelectorAll(".swatch").forEach(b=>b.classList.toggle("on",b.dataset.t===settings.theme));
  $("sCards").value=settings.cards;
  $("sAnim").classList.toggle("on",!!settings.anim);
  $("sLanding").value=settings.landing;
  $("sEngine").value=engineSel.value;
  $("wispInput").value=settings.wisp;
  $("wispNow").textContent="In use: "+effWisp();
  const out=$("wispTestOut");
  out.textContent=""; out.className="wout";
}

$("settingsBtn").addEventListener("click",openSettings);
$("sClose").addEventListener("click",closeSettings);
settingsModal.querySelector(".sback").addEventListener("click",closeSettings);

document.querySelectorAll(".swatch").forEach(b=>b.addEventListener("click",()=>{
  settings.theme=b.dataset.t;
  store.set("gn_theme",settings.theme);
  applySettings(); syncSettingsUI();
  toast("Theme: "+(settings.theme==="red"?"Red":"Purple"));
}));

$("sCards").addEventListener("change",e=>{
  settings.cards=e.target.value;
  store.set("gn_cards",settings.cards);
  applySettings();
});

$("sAnim").addEventListener("click",()=>{
  settings.anim=!settings.anim;
  store.set("gn_anim",settings.anim);
  applySettings(); syncSettingsUI();
});

$("sLanding").addEventListener("change",e=>{
  settings.landing=e.target.value;
  store.set("gn_landing",settings.landing);
  toast("Starts on "+(settings.landing==="library"?"the Library":"Home")+" next visit");
});

/* engine: sync home select + storage */
$("sEngine").addEventListener("change",e=>{
  localStorage.setItem("aa_engine",e.target.value);
  engineSel.value=e.target.value;
});

/* wisp server override */
$("wispInput").addEventListener("change",e=>{
  settings.wisp=e.target.value.trim();
  store.set("aa_wisp",settings.wisp);
  $("wispNow").textContent="In use: "+effWisp();
  toast(settings.wisp ? "Custom server saved \u2014 applies on next browse" : "Using the built-in server");
});

$("wispTest").addEventListener("click",async()=>{
  const url=$("wispInput").value.trim();
  const out=$("wispTestOut");
  if(!url){
    out.textContent="Enter a server URL first \u2014 or clear the field to use the built-in one.";
    out.className="wout";
    return;
  }
  out.textContent="Testing\u2026"; out.className="wout";
  const ok=await new Promise(res=>{
    let ws, done=false;
    const fin=v=>{ if(!done){ done=true; try{ws.close();}catch(e){} res(v); } };
    try{ ws=new WebSocket(url); }catch(e){ return res(false); }
    ws.onopen=()=>fin(true);
    ws.onerror=()=>fin(false);
    ws.onclose=()=>fin(false);
    setTimeout(()=>fin(false),6000);
  });
  out.textContent = ok ? "\u2713 Connected \u2014 server is awake" : "\u2717 Could not connect within 6s";
  out.className="wout "+(ok?"good":"bad");
});

/* data management */
$("sClearRecent").addEventListener("click",()=>{
  recent=[]; store.set("gn_recent",recent); renderRecent();
  toast("Recently played cleared");
});

$("sClearFavs").addEventListener("click",()=>{
  if(favs.size===0){ toast("No favorites to clear"); return; }
  if(!confirm("Remove all favorites?")) return;
  favs.clear(); store.set("gn_favs",[]);
  renderFavCount(); renderGrid();
  document.querySelectorAll(".favbtn.on").forEach(b=>b.classList.remove("on"));
  toast("Favorites cleared");
});

$("sReset").addEventListener("click",()=>{
  if(!confirm("Reset ALL site data?\n(theme, favorites, history, proxy settings \u2014 everything)")) return;
  try{ localStorage.clear(); }catch(e){}
  location.reload();
});

/* ============================== TOOLBAR ============================== */
let raf=null;
searchBox.addEventListener("input",()=>{
  if(raf) cancelAnimationFrame(raf);
  raf=requestAnimationFrame(()=>{ query=searchBox.value; renderGrid(); raf=null; });
});

const sortSel=$("sort");
sortSel.value=sort;
sortSel.addEventListener("change",()=>{
  sort=sortSel.value; store.set("gn_sort",sort);
  if(sort==="rnd") for(const g of GAMES) g.r=Math.random();
  renderGrid();
});
if(sort==="rnd") for(const g of GAMES) g.r=Math.random();

$("favToggle").addEventListener("click",()=>{
  favsOnly=!favsOnly;
  $("favToggle").classList.toggle("on",favsOnly);
  renderGrid();
});

$("randomBtn").addEventListener("click",()=>{
  openGame(NAV[Math.floor(Math.random()*NAV.length)].f);
});

/* ============================== MISC UI ============================== */
let toastTimer=null;
function toast(msg){
  const t=$("toast");
  t.textContent=msg; t.classList.add("show");
  clearTimeout(toastTimer);
  toastTimer=setTimeout(()=>t.classList.remove("show"),1700);
}

const toTop=$("toTop");
addEventListener("scroll",()=>toTop.classList.toggle("show",scrollY>700),{passive:true});
toTop.addEventListener("click",()=>scrollTo({top:0,behavior:"smooth"}));

document.addEventListener("keydown",e=>{
  if(settingsModal.classList.contains("active")){
    if(e.key==="Escape") closeSettings();
    return;
  }
  if($("browse").classList.contains("active")){
    if(e.key==="Escape") hideBrowse();
    return;
  }
  if($("player").classList.contains("active")){
    if(e.key==="Escape") location.hash="";
    else if(e.key==="ArrowLeft") step(-1);
    else if(e.key==="ArrowRight") step(1);
    else if(e.key==="f"||e.key==="F") toggleFullscreen();
    return;
  }
  const typing=/INPUT|SELECT|TEXTAREA/.test(document.activeElement.tagName);
  if(!typing&&e.key==="/"){ e.preventDefault(); showView("library"); searchBox.focus(); }
});

/* ============================== INIT ============================== */
applySettings();
$("tagline").textContent=GAMES.length+" games \u00B7 unblocked browser";
$("heroCount").textContent=GAMES.length;
$("statGames").textContent=GAMES.length;
$("statCovers").textContent=[...cardCache.values()].filter(c=>c.querySelector("img")).length;
$("footCount").textContent=GAMES.length;
$("sCount").textContent=GAMES.length;
renderFavCount();
renderRecent();
renderFeatured();

/* wake the effective wisp server early so it is (mostly) awake when needed */
try{
  const w=effWisp();
  if(w) fetch(w.replace("wss://","https://").replace(/\/wisp\/?$/,"/"),{mode:"no-cors"}).catch(()=>{});
}catch(e){}

route(true);
if(isFile()) setStatus("\u26A0 Proxy needs hosting (https / localhost) \u2014 games work offline.");
</script>
</body>
</html>
'@

# ---- collect game files (skip the launcher itself) ----
$set = @{}
if (Test-Path $coversDir) {
    Get-ChildItem $coversDir -File | ForEach-Object { $set[$_.Name] = $true }
}

$games = Get-ChildItem -Path $dir -File |
    Where-Object { $_.Name -cne 'index.html' -and $_.Name -cmatch '\.html' }

$items = foreach ($f in $games) {
    $base = $f.Name -replace '\.html$',''
    $n = 999999; $s = ''
    if ($base -cmatch '^(\d+)[-.](.+)$') { $n = [int]$matches[1]; $s = $matches[2] }
    elseif ($base -cmatch '^(\d+)$')     { $n = [int]$matches[1] }

    # cover resolution: exact number+suffix jpg, then plain number jpg, then any other format (png/gif/webp/avif)
    $c = $null
    if ($s -ne '' -and $set.ContainsKey(("{0}-{1}.jpg" -f $n, $s))) { $c = "covers/{0}-{1}.jpg" -f $n, $s }
    elseif ($set.ContainsKey(("{0}.jpg" -f $n))) { $c = "covers/{0}.jpg" -f $n }
    else {
        $alt = $set.Keys |
            Where-Object { $_ -cmatch ('^' + [regex]::Escape([string]$n) + '\.(png|gif|webp|avif|jpe?g|bmp)$') } |
            Sort-Object | Select-Object -First 1
        if ($alt) { $c = "covers/$alt" }
    }
    [pscustomobject]@{ F = $f.Name; N = $n; S = $s; C = $c }
}
$sorted = $items | Sort-Object N, F

# ---- build the JS array ----
$nl = [Environment]::NewLine
$lines = foreach ($g in $sorted) {
    $f = $g.F -replace '\\','\\\\' -replace '"','\"'
    $s = $g.S -replace '\\','\\\\' -replace '"','\"'
    $c = if ($g.C) { '"' + $g.C + '"' } else { 'null' }
    '  {{f:"{0}",n:{1},s:"{2}",c:{3}}}' -f $f, $g.N, $s, $c
}
$arr = '[' + $nl + ($lines -join (',' + $nl)) + $nl + ']'

# ---- inline the theme-aware logo (CSS vars inside cascade into inline SVG only) ----
$logoSvg = ''
$logoPath = Join-Path $dir 'logo.svg'
if (Test-Path $logoPath) {
    $logoSvg = (Get-Content $logoPath -Raw).Trim()
    $logoSvg = $logoSvg.Replace('<svg ', '<svg class="logo-img" aria-hidden="true" ')
} else {
    $logoSvg = '<img class="logo-img" src="favicon.png" alt="" aria-hidden="true">'
}

$html = $template.Replace('__GAMES__', $arr).Replace('__LOGO_HEADER__', $logoSvg).Replace('__LOGO_HERO__', $logoSvg)
Set-Content -Path (Join-Path $dir 'index.html') -Value $html -Encoding UTF8 -NoNewline

$withCovers = @($sorted | Where-Object { $_.C }).Count
Write-Output ("index.html generated: {0} games, {1} with covers" -f $sorted.Count, $withCovers)
