import{c as a,j as e,H as s}from"./index-dDFZ_N5A.js";/**
 * @license lucide-react v1.11.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const x=[["circle",{cx:"12",cy:"12",r:"10",key:"1mglay"}],["line",{x1:"12",x2:"12",y1:"8",y2:"12",key:"1pkeuh"}],["line",{x1:"12",x2:"12.01",y1:"16",y2:"16",key:"4dfq90"}]],m=a("circle-alert",x);/**
 * @license lucide-react v1.11.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const f=[["circle",{cx:"12",cy:"12",r:"10",key:"1mglay"}],["path",{d:"m9 12 2 2 4-4",key:"dzmm74"}]],g=a("circle-check",f);/**
 * @license lucide-react v1.11.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const y=[["circle",{cx:"12",cy:"12",r:"10",key:"1mglay"}],["path",{d:"M12 16v-4",key:"1dtifu"}],["path",{d:"M12 8h.01",key:"e9boi3"}]],d=a("info",y);/**
 * @license lucide-react v1.11.0 - ISC
 *
 * This source code is licensed under the ISC license.
 * See the LICENSE file in the root directory of this source tree.
 */const p=[["path",{d:"m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3",key:"wmoenq"}],["path",{d:"M12 9v4",key:"juzpu7"}],["path",{d:"M12 17h.01",key:"p32p05"}]],h=a("triangle-alert",p),n={default:{root:"border text-foreground",icon:e.jsx(d,{className:"size-4"})},info:{root:"border bg-muted/50 text-foreground",icon:e.jsx(d,{className:"size-4 text-muted-foreground"})},success:{root:"border bg-background text-foreground",icon:e.jsx(g,{className:"size-4 text-muted-foreground"})},warning:{root:"border bg-muted/50 text-foreground",icon:e.jsx(h,{className:"size-4 text-muted-foreground"})},destructive:{root:"border-destructive/40 bg-destructive/5 text-destructive",icon:e.jsx(m,{className:"size-4 text-destructive"})}};function j({className:r,title:t,description:c,variant:o="default",icon:i,children:l,...u}){return e.jsx("div",{"data-slot":"alert",className:s("relative w-full rounded-lg border px-4 py-3 text-sm",n[o].root,r),...u,children:e.jsxs("div",{className:"flex items-start gap-3",children:[e.jsx("div",{className:"shrink-0 translate-y-0.5",children:i??n[o].icon}),e.jsxs("div",{className:"min-w-0 space-y-1",children:[t?e.jsx("div",{className:"font-medium",children:t}):null,c?e.jsx("div",{className:"text-sm text-current/90",children:c}):null,l]})]})})}function v({className:r,...t}){return e.jsx("div",{"data-slot":"card",className:s("bg-card text-card-foreground flex flex-col rounded-lg border shadow-sm",r),...t})}function b({className:r,...t}){return e.jsx("div",{"data-slot":"card-header",className:s("flex flex-col gap-1.5 p-6",r),...t})}function k({className:r,...t}){return e.jsx("div",{"data-slot":"card-title",className:s("leading-none font-semibold",r),...t})}function C({className:r,...t}){return e.jsx("div",{"data-slot":"card-description",className:s("text-muted-foreground text-sm",r),...t})}function _({className:r,...t}){return e.jsx("div",{"data-slot":"card-content",className:s("p-6 pt-0",r),...t})}export{j as A,v as C,b as a,k as b,C as c,_ as d};
