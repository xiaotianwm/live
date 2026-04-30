import{c as g,j as T,H as k,I as S}from"./index-BhyF_s_i.js";/**
 * @license lucide-react v1.11.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const z=[["path",{d:"m9 18 6-6-6-6",key:"mthhwq"}]],F=g("chevron-right",z);/**
 * @license lucide-react v1.11.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const _=[["circle",{cx:"12",cy:"12",r:"10",key:"1mglay"}],["path",{d:"m15 9-6 6",key:"1uzhvr"}],["path",{d:"m9 9 6 6",key:"z0biqf"}]],X=g("circle-x",_);/**
 * @license lucide-react v1.11.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const $=[["path",{d:"M12 13v8",key:"1l5pq0"}],["path",{d:"M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242",key:"1pljnt"}],["path",{d:"m8 17 4-4 4 4",key:"1quai1"}]],j=g("cloud-upload",$);/**
 * @license lucide-react v1.11.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const H=[["path",{d:"M12 15V3",key:"m9g1x1"}],["path",{d:"M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4",key:"ih7n3h"}],["path",{d:"m7 10 5 5 5-5",key:"brsn70"}]],B=g("download",H);/**
 * @license lucide-react v1.11.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const q=[["path",{d:"M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0",key:"1nclc0"}],["circle",{cx:"12",cy:"12",r:"3",key:"1v7zrd"}]],V=g("eye",q);function W({value:t,className:a,indicatorClassName:e}){const r=Math.max(0,Math.min(100,Number.isFinite(t)?t:0));return T.jsx("div",{className:k("relative h-2 w-full overflow-hidden rounded-full bg-secondary",a),children:T.jsx("div",{className:k("h-full w-full flex-1 bg-primary transition-all",e),style:{transform:`translateX(-${100-r}%)`}})})}const A=12;async function Y(t,a,e){return a.strategy==="multipart"?D(t,a,e):(await R(t,a.method||"PUT",a.uploadUrl,t.type,e.onProgress,e.signal),[])}async function D(t,a,e){var m,w,C,P;const r=Math.max(t.size,0),c=Math.max(a.partSize||0,1),s=Math.max(a.totalParts||Math.ceil(r/c),1),l=[],i=new Map;let o=1,u=null;const d=new AbortController,f=()=>{d.abort()};if((m=e.signal)!=null&&m.aborted)throw x();(w=e.signal)==null||w.addEventListener("abort",f,{once:!0});const p=()=>{if(!e.onProgress)return;let n=0;for(const M of i.values())n+=M;const h=Math.max(0,Math.min(r,n)),E=r>0?Math.max(0,Math.min(100,Math.round(h/r*100))):0;e.onProgress({loaded:h,total:r,percent:E})},b=async()=>{for(;!d.signal.aborted;){const n=o;if(o+=1,n>s)return;const h=(n-1)*c,E=Math.min(t.size,h+c),M=t.slice(h,E);i.set(n,0),p();try{const y=await S(a.uploadSessionId,n,d.signal),U=await R(M,y.method||"PUT",y.uploadUrl,t.type,L=>{i.set(n,L.loaded),p()},d.signal);i.set(n,M.size),l.push({partNumber:n,etag:U}),p()}catch(y){throw u||(u=y),d.abort(),y}}};try{const n=Math.max(1,Math.min(A,s));await Promise.all(Array.from({length:n},()=>b()))}catch(n){throw N(n)||N(u)||(C=e.signal)!=null&&C.aborted?x():u||n}finally{(P=e.signal)==null||P.removeEventListener("abort",f)}return l.sort((n,h)=>n.partNumber-h.partNumber),l}function R(t,a,e,r,c,s){return new Promise((l,i)=>{const o=new XMLHttpRequest,u=()=>{o.abort()};if(o.open(a||"PUT",e,!0),s!=null&&s.aborted){i(x());return}s==null||s.addEventListener("abort",u,{once:!0});const d=()=>{s==null||s.removeEventListener("abort",u)};o.upload.onprogress=p=>{if(!p.lengthComputable||!c)return;const b=Math.max(0,p.loaded),m=Math.max(p.total,t.size,0),w=m>0?Math.max(0,Math.min(100,Math.round(b/m*100))):0;c({loaded:b,total:m,percent:w})},o.onerror=()=>{d(),i(new Error(v("file upload failed",e,o)))},o.ontimeout=()=>{d(),i(new Error(v("file upload timed out",e,o)))},o.onabort=()=>{d(),i(x())},o.onload=()=>{if(d(),o.status>=200&&o.status<300){l((o.getResponseHeader("ETag")||"").trim());return}i(new Error(v("file upload failed",e,o)))};const f=r.trim();f&&o.setRequestHeader("Content-Type",f),o.send(t)})}function x(){const t=new Error("upload canceled");return t.name="UploadCanceledError",t}function N(t){return t instanceof Error&&t.name==="UploadCanceledError"}function v(t,a,e){const r=I(a,e),c=[t];return r.status>0&&c.push(`HTTP ${r.status}`),r.targetHost&&c.push(`target ${r.targetHost}`),r.compactResponseText&&c.push(r.compactResponseText),r.readyState>0&&c.push(`readyState ${r.readyState}`),r.pageOrigin&&c.push(`page ${r.pageOrigin}`),c.join(" | ")}function I(t,a){const e=(a.responseURL||t||"").trim(),r=(()=>{if(!e)return"";try{return new URL(e).host}catch{return""}})(),c=typeof window<"u"?window.location.origin:"",s=typeof a.responseText=="string"?a.responseText.trim():"",l=s.length>120?`${s.slice(0,117).trimEnd()}...`:s;return{pageOrigin:c,readyState:a.readyState,requestURL:e,targetHost:r,compactResponseText:l,status:a.status}}export{F as C,B as D,V as E,W as P,j as a,X as b,Y as u};
