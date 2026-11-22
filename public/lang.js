(()=>{const s=document.querySelector('select.lang'),
secs=document.querySelectorAll('main [lang]:not(option)'),
has=l=>[...s.options].some(o=>o.value===l),
pick=l=>{for(const x of secs)x.hidden=x.lang!==l;s.value=l;
document.documentElement.lang=l;
document.title=document.querySelector('h1').innerText+' - Seed'},
h=location.hash.slice(1),n=navigator.language.slice(0,2);
let saved;try{saved=localStorage.getItem('lang')}catch(e){}
pick(has(h)?h:has(saved)?saved:has(n)?n:s.options[0].value);s.hidden=false;
s.onchange=()=>{pick(s.value);history.replaceState(null,'','#'+s.value);
try{localStorage.setItem('lang',s.value)}catch(e){}}})();
