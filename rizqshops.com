#rizqshops.com
Skip to main content
Skip to search
Skip to select language

OPEN MAIN MENU

References
postMessage()


Filter sidebar
Filter
In this article
Syntax
The dispatched event
Security concerns
Examples
Specifications
Browser compatibility
See also
HTML DOM API
Window
Instance properties
closed
console
credentialless
ExperimentalNon-standard
customElements
defaultStatus
Deprecated
devicePixelRatio
document
documentPictureInPicture
Experimental
event
Deprecated
external
Deprecated
frameElement
frames
fullScreen
Non-standard
history
innerHeight
innerWidth
launchQueue
Experimental
length
localStorage
location
locationbar
menubar
mozInnerScreenX
Non-standard
mozInnerScreenY
Non-standard
name
navigation
Experimental
navigator
ondragdrop
Deprecated
opener
orientation
Deprecated
outerHeight
outerWidth
pageXOffset
pageYOffset
parent
personalbar
scheduler
screen
screenLeft
screenTop
screenX
screenY
scrollbars
scrollMaxX
Non-standard
scrollMaxY
Non-standard
scrollX
scrollY
self
sessionStorage
sidebar
Non-standardDeprecated
speechSynthesis
status
Deprecated
statusbar
toolbar
top
visualViewport
window
Instance methods
alert()
back()
Non-standardDeprecated
blur()
cancelAnimationFrame()
cancelIdleCallback()
captureEvents()
Deprecated
clearImmediate()
Non-standardDeprecated
close()
confirm()
dump()
Non-standard
find()
Non-standard
focus()
forward()
Non-standardDeprecated
getComputedStyle()
getDefaultComputedStyle()
Non-standard
getSelection()
matchMedia()
moveBy()
moveTo()
open()
postMessage()
print()
prompt()
queryLocalFonts()
Experimental
releaseEvents()
Deprecated
requestAnimationFrame()
requestFileSystem()
Non-standardDeprecated
requestIdleCallback()
resizeBy()
resizeTo()
scroll()
scrollBy()
scrollByLines()
Non-standard
scrollByPages()
Non-standard
scrollTo()
setImmediate()
Non-standardDeprecated
showDirectoryPicker()
Experimental
showModalDialog()
Non-standardDeprecated
showOpenFilePicker()
Experimental
showSaveFilePicker()
Experimental
sizeToContent()
Non-standard
stop()
updateCommands()
Non-standard
webkitConvertPointFromNodeToPage()
Non-standardDeprecated
webkitConvertPointFromPageToNode()
Non-standardDeprecated
Events
afterprint
appinstalled
beforeinstallprompt
beforeprint
beforeunload
blur
copy
cut
devicemotion
deviceorientation
deviceorientationabsolute
error
focus
gamepadconnected
gamepaddisconnected
hashchange
languagechange
load
message
messageerror
offline
online
orientationchange
Deprecated
pagehide
pageshow
paste
popstate
rejectionhandled
resize
storage
unhandledrejection
unload
vrdisplayactivate
Non-standardDeprecated
vrdisplayconnect
Non-standardDeprecated
vrdisplaydeactivate
Non-standardDeprecated
vrdisplaydisconnect
Non-standardDeprecated
vrdisplaypresentchange
Non-standardDeprecated
Inheritance:
EventTarget
Related pages for HTML DOM
BeforeUnloadEvent
DOMStringMap
ErrorEvent
HTMLAnchorElement
HTMLAreaElement
HTMLAudioElement
HTMLBRElement
HTMLBaseElement
HTMLBodyElement
HTMLButtonElement
HTMLCanvasElement
HTMLDListElement
HTMLDataElement
HTMLDataListElement
HTMLDialogElement
HTMLDivElement
HTMLDocument
HTMLElement
HTMLEmbedElement
HTMLFieldSetElement
HTMLFormControlsCollection
HTMLFormElement
HTMLFrameSetElement
HTMLHRElement
HTMLHeadElement
HTMLHeadingElement
HTMLHtmlElement
HTMLIFrameElement
HTMLImageElement
HTMLInputElement
HTMLLIElement
HTMLLabelElement
HTMLLegendElement
HTMLLinkElement
HTMLMapElement
HTMLMediaElement
HTMLMetaElement
HTMLMeterElement
HTMLModElement
HTMLOListElement
HTMLObjectElement
HTMLOptGroupElement
HTMLOptionElement
HTMLOptionsCollection
HTMLOutputElement
HTMLParagraphElement
HTMLPictureElement
HTMLPreElement
HTMLProgressElement
HTMLQuoteElement
HTMLScriptElement
HTMLSelectElement
HTMLSourceElement
HTMLSpanElement
HTMLStyleElement
HTMLTableCaptionElement
HTMLTableCellElement
HTMLTableColElement
HTMLTableElement
HTMLTableRowElement
HTMLTableSectionElement
HTMLTemplateElement
HTMLTextAreaElement
HTMLTimeElement
HTMLTitleElement
HTMLTrackElement
HTMLUListElement
HTMLUnknownElement
HTMLVideoElement
HashChangeEvent
History
ImageData
Location
MessageChannel
MessageEvent
MessagePort
Navigator
PageTransitionEvent
Plugin
PluginArray
PromiseRejectionEvent
RadioNodeList
UserActivation
ValidityState
WorkletGlobalScope
Window: postMessage() method
The window.postMessage() method safely enables cross-origin communication between Window objects; e.g., between a page and a pop-up that it spawned, or between a page and an iframe embedded within it.

Normally, scripts on different pages are allowed to access each other if and only if the pages they originate from share the same protocol, port number, and host (also known as the "same-origin policy"). window.postMessage() provides a controlled mechanism to securely circumvent this restriction (if used properly).

Broadly, one window may obtain a reference to another (e.g., via targetWindow = window.opener), and then dispatch a MessageEvent on it with targetWindow.postMessage(). The receiving window is then free to handle this event as needed. The arguments passed to window.postMessage() (i.e., the "message") are exposed to the receiving window through the event object.

Syntax
JS
Copy to Clipboard

postMessage(message)
postMessage(message, options)
postMessage(message, targetOrigin)
postMessage(message, targetOrigin, transfer)
Parameters
message
Data to be sent to the other window. The data is serialized using the structured clone algorithm. This means you can pass a broad variety of data objects safely to the destination window without having to serialize them yourself.

options Optional
An optional object containing a transfer field with a sequence of transferable objects to transfer ownership of, and a optional targetOrigin field with a string which restricts the message to the limited targets only.

targetOrigin Optional
Specifies what the origin of this window must be for the event to be dispatched, either as the literal string "*" (indicating no preference) or as a URI. If at the time the event is scheduled to be dispatched the scheme, hostname, or port of this window's document does not match that provided in targetOrigin, the event will not be dispatched; only if all three match will the event be dispatched. This mechanism provides control over where messages are sent; for example, if postMessage() was used to transmit a password, it would be absolutely critical that this argument be a URI whose origin is the same as the intended receiver of the message containing the password, to prevent interception of the password by a malicious third party. Always provide a specific targetOrigin, not *, if you know where the other window's document should be located. Failing to provide a specific target discloses the data you send to any interested malicious site.

transfer Optional
A sequence of transferable objects that are transferred with the message. The ownership of these objects is given to the destination side and they are no longer usable on the sending side.

Return value
None (undefined).

The dispatched event
A window can listen for dispatched messages by executing the following JavaScript:

JS
Copy to Clipboard

window.addEventListener(
  "message",
  (event) => {
    if (event.origin !== "http://example.org:8080") return;

    // …
  },
  false,
);
The properties of the dispatched message are:

data
The object passed from the other window.

origin
The origin of the window that sent the message at the time postMessage was called. This string is the concatenation of the protocol and "://", the host name if one exists, and ":" followed by a port number if a port is present and differs from the default port for the given protocol. Examples of typical origins are https://example.org (implying port 443), http://example.net (implying port 80), and http://example.com:8080. Note that this origin is not guaranteed to be the current or future origin of that window, which might have been navigated to a different location since postMessage was called.

source
A reference to the window object that sent the message; you can use this to establish two-way communication between two windows with different origins.

Security concerns
If you do not expect to receive messages from other sites, do not add any event listeners for message events. This is a completely foolproof way to avoid security problems.

If you do expect to receive messages from other sites, always verify the sender's identity using the origin and possibly source properties. Any window (including, for example, http://evil.example.com) can send a message to any other window, and you have no guarantees that an unknown sender will not send malicious messages. Having verified identity, however, you still should always verify the syntax of the received message. Otherwise, a security hole in the site you trusted to send only trusted messages could then open a cross-site scripting hole in your site.

Always specify an exact target origin, not *, when you use postMessage to send data to other windows. A malicious site can change the location of the window without your knowledge, and therefore it can intercept the data sent using postMessage.

Secure shared memory messaging
If postMessage() throws when used with SharedArrayBuffer objects, you might need to make sure you cross-site isolated your site properly. Shared memory is gated behind two HTTP headers:

Cross-Origin-Opener-Policy with same-origin as value (protects your origin from attackers)
Cross-Origin-Embedder-Policy with require-corp or credentialless as value (protects victims from your origin)
HTTP
Copy to Clipboard

Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
To check if cross origin isolation has been successful, you can test against the crossOriginIsolated property available to window and worker contexts:

JS
Copy to Clipboard

const myWorker = new Worker("worker.js");

if (crossOriginIsolated) {
  const buffer = new SharedArrayBuffer(16);
  myWorker.postMessage(buffer);
} else {
  const buffer = new ArrayBuffer(16);
  myWorker.postMessage(buffer);
}
Examples
JS
Copy to Clipboard

/*
 * In window A's scripts, with A being on http://example.com:8080:
 */

const popup = window.open(/* popup details */);

// When the popup has fully loaded, if not blocked by a popup blocker:

// This does nothing, assuming the window hasn't changed its location.
popup.postMessage(
  "The user is 'bob' and the password is 'secret'",
  "https://secure.example.net",
);

// This will successfully queue a message to be sent to the popup, assuming
// the window hasn't changed its location.
popup.postMessage("hello there!", "http://example.com");

window.addEventListener(
  "message",
  (event) => {
    // Do we trust the sender of this message?  (might be
    // different from what we originally opened, for example).
    if (event.origin !== "http://example.com") return;

    // event.source is popup
    // event.data is "hi there yourself!  the secret response is: rheeeeet!"
  },
  false,
);
JS
Copy to Clipboard

/*
 * In the popup's scripts, running on http://example.com:
 */

// Called sometime after postMessage is called
window.addEventListener("message", (event) => {
  // Do we trust the sender of this message?
  if (event.origin !== "http://example.com:8080") return;

  // event.source is window.opener
  // event.data is "hello there!"

  // Assuming you've verified the origin of the received message (which
  // you must do in any case), a convenient idiom for replying to a
  // message is to call postMessage on event.source and provide
  // event.origin as the targetOrigin.
  event.source.postMessage(
    "hi there yourself!  the secret response " + "is: rheeeeet!",
    event.origin,
  );
});
Notes
Any window may access this method on any other window, at any time, regardless of the location of the document in the window, to send it a message. Consequently, any event listener used to receive messages must first check the identity of the sender of the message, using the origin and possibly source properties. This cannot be overstated: Failure to check the origin and possibly source properties enables cross-site scripting attacks.

As with any asynchronously-dispatched script (timeouts, user-generated events), it is not possible for the caller of postMessage to detect when an event handler listening for events sent by postMessage throws an exception.

After postMessage() is called, the MessageEvent will be dispatched only after all pending execution contexts have finished. For example, if postMessage() is invoked in an event handler, that event handler will run to completion, as will any remaining handlers for that same event, before the MessageEvent is dispatched.

The value of the origin property of the dispatched event is not affected by the current value of document.domain in the calling window.

For IDN host names only, the value of the origin property is not consistently Unicode or punycode; for greatest compatibility check for both the IDN and punycode values when using this property if you expect messages from IDN sites. This value will eventually be consistently IDN, but for now you should handle both IDN and punycode forms.

The value of the origin property when the sending window contains a javascript: or data: URL is the origin of the script that loaded the URL.

Using window.postMessage in extensions Non-standard
window.postMessage is available to JavaScript running in chrome code (e.g., in extensions and privileged code), but the source property of the dispatched event is always null as a security restriction. (The other properties have their expected values.)

It is not possible for content or web context scripts to specify a targetOrigin to communicate directly with an extension (either the background script or a content script). Web or content scripts can use window.postMessage with a targetOrigin of "*" to broadcast to every listener, but this is discouraged, since an extension cannot be certain the origin of such messages, and other listeners (including those you do not control) can listen in.

Content scripts should use runtime.sendMessage to communicate with the background script. Web context scripts can use custom events to communicate with content scripts (with randomly generated event names, if needed, to prevent snooping from the guest page).

Lastly, posting a message to a page at a file: URL currently requires that the targetOrigin argument be "*". file:// cannot be used as a security restriction; this restriction may be modified in the future.

Specifications
Specification
HTML Standard
# dom-window-postmessage-options-dev
Browser compatibility
Report problems with this compatibility data on GitHub
postMessage

Full support
Chrome
2
Toggle history

Full support
Edge
12
Toggle history

Full support
Firefox
3
footnote
Toggle history

Full support
Opera
9.5
Toggle history

Full support
Safari
4
Toggle history

Full support
Chrome Android
18
Toggle history

Full support
Firefox for Android
4
footnote
Toggle history

Full support
Opera Android
10.1
Toggle history

Full support
Safari on iOS
3.2
Toggle history

Full support
Samsung Internet
1.0
Toggle history

Full support
WebView Android
37
Toggle history
transfer parameter

Full support
Chrome
4
Toggle history

Full support
Edge
12
Toggle history

Full support
Firefox
20
Toggle history

Full support
Opera
15
Toggle history

Full support
Safari
5
Toggle history

Full support
Chrome Android
18
Toggle history

Full support
Firefox for Android
20
Toggle history

Full support
Opera Android
14
Toggle history

Full support
Safari on iOS
4
Toggle history

Full support
Samsung Internet
1.0
Toggle history

Full support
WebView Android
37
Toggle history
Legend
Tip: you can click/tap on a cell for more information.

Full support
Full support
See implementation notes.
See also
Document.domain
CustomEvent
BroadcastChannel - For same-origin communication.
Found a content problem with this page?
Edit the page on GitHub.
Report the content issue.
View the source on GitHub.
Want to get more involved? Learn how to contribute.
This page was last modified on Oct 2, 2023 by MDN contributors.

Your blueprint for a better internet.

MDN on Twitter
MDN on GitHub
MDN Blog RSS Feed
MDN
About
Blog
Careers
Advertise with us
Support
Product help
Report an issue
Our communities
MDN Community
MDN Forum
MDN Chat
Developers
Web Technologies
Learn Web Development
MDN Plus
Hacks Blog
Website Privacy Notice
Cookies
Legal
Community Participation Guidelines
Visit Mozilla Corporation’s not-for-profit parent, the Mozilla Foundation.
Portions of this content are ©1998–2023 by individual mozilla.org contributors. Content available under a Creative Commons license.

