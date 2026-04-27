import{c as d,j as w,H as x}from"./index-BANhi3Or.js";/**
 * @license lucide-react v1.11.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const E=[["path",{d:"m9 18 6-6-6-6",key:"mthhwq"}]],C=d("chevron-right",E);/**
 * @license lucide-react v1.11.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const M=[["circle",{cx:"12",cy:"12",r:"10",key:"1mglay"}],["path",{d:"m15 9-6 6",key:"1uzhvr"}],["path",{d:"m9 9 6 6",key:"z0biqf"}]],H=d("circle-x",M);/**
 * @license lucide-react v1.11.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const k=[["path",{d:"M12 13v8",key:"1l5pq0"}],["path",{d:"M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242",key:"1pljnt"}],["path",{d:"m8 17 4-4 4 4",key:"1quai1"}]],N=d("cloud-upload",k);/**
 * @license lucide-react v1.11.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const v=[["path",{d:"M12 15V3",key:"m9g1x1"}],["path",{d:"M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4",key:"ih7n3h"}],["path",{d:"m7 10 5 5 5-5",key:"brsn70"}]],S=d("download",v);/**
 * @license lucide-react v1.11.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const T=[["path",{d:"M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0",key:"1nclc0"}],["circle",{cx:"12",cy:"12",r:"3",key:"1v7zrd"}]],q=d("eye",T);function L({value:e,className:n,indicatorClassName:o}){const t=Math.max(0,Math.min(100,Number.isFinite(e)?e:0));return w.jsx("div",{className:x("relative h-2 w-full overflow-hidden rounded-full bg-secondary",n),children:w.jsx("div",{className:x("h-full w-full flex-1 bg-primary transition-all",o),style:{transform:`translateX(-${100-t}%)`}})})}async function U(e,n,o){return await R(e,n.method||"PUT",n.uploadUrl,e.type,o.onProgress,o.signal),[]}function R(e,n,o,t,s,a){return new Promise((u,c)=>{const r=new XMLHttpRequest,m=()=>{r.abort()};if(r.open(n,o,!0),a!=null&&a.aborted){c(g());return}a==null||a.addEventListener("abort",m,{once:!0});const i=()=>{a==null||a.removeEventListener("abort",m)};r.upload.onprogress=p=>{if(!p.lengthComputable||!s)return;const f=Math.max(0,p.loaded),l=Math.max(p.total,e.size,0),b=l>0?Math.max(0,Math.min(100,Math.round(f/l*100))):0;s({loaded:f,total:l,percent:b})},r.onerror=()=>{i(),c(new Error(h("文件直传失败",o,r)))},r.ontimeout=()=>{i(),c(new Error(h("文件直传超时",o,r)))},r.onabort=()=>{i(),c(g())},r.onload=()=>{if(i(),r.status>=200&&r.status<300){u((r.getResponseHeader("ETag")||"").trim());return}c(new Error(h("文件直传失败",o,r)))};const y=t.trim();y&&r.setRequestHeader("Content-Type",y),r.send(e)})}function g(){const e=new Error("上传已取消");return e.name="UploadCanceledError",e}function h(e,n,o){const t=_(n,o),s=[e];return t.status>0&&s.push(`HTTP ${t.status}`),t.targetHost&&s.push(`目标 ${t.targetHost}`),t.compactResponseText&&s.push(t.compactResponseText),t.readyState>0&&s.push(`readyState ${t.readyState}`),t.pageOrigin&&s.push(`页面 ${t.pageOrigin}`),s.join(" | ")}function _(e,n){const o=(n.responseURL||e||"").trim(),t=(()=>{if(!o)return"";try{return new URL(o).host}catch{return""}})(),s=typeof window<"u"?window.location.origin:"",a=typeof n.responseText=="string"?n.responseText.trim():"",u=a.length>120?`${a.slice(0,117).trimEnd()}...`:a;return{pageOrigin:s,readyState:n.readyState,requestURL:o,targetHost:t,compactResponseText:u,status:n.status}}export{C,S as D,q as E,L as P,N as a,H as b,U as u};
