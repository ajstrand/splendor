export function createTextNode(text) {
  if (globalThis.document == undefined) {
    throw "`document` is `undefined`. Did you forget to call `jsdom.init()`?";
  }
  return document.createTextNode(text);
}

export function getElementById(id) {
  if (globalThis.document == undefined) {
    throw "`document` is `undefined`. Make sure it's defined in your environment. For nodeJS/servers, call jsdom.init`?";
  }
  try {  
    const isId = id.includes("#") ? true : false
    if(isId){
      return document.getElementById(id)
    }

    // if something unexpected
    const message = `${id} is not an Id attribute in the DOM.  
    Check if you're using the right selector. 
    If you're not wanting to access an element by Id, you may want to use the "get_query_selector" function in dom.gleam`;
    throw new Error(message);     
  
  } catch (e) {
    console.error(e);
  }
}

export function querySelector(tag) {
  console.log(`in querySelector trying to find ${tag}`)
  if (globalThis.document == undefined) {
    throw "`document` is `undefined`. Make sure it's defined in your environment. For nodeJS/servers, call jsdom.init`?";
  }
  return document.querySelector(tag)
}

export function createElement(tag) {
  if (globalThis.document == undefined) {
    throw "`document` is `undefined`. Did you forget to call `jsdom.init()`?";
  }
  return document.createElement(tag);
}

export function appendChild(element, child) {
  try {  
    return element.appendChild(child);
    // if something unexpected
    throw new Error("Something unexpected has occurred.");     
  
  } catch (e) {
    console.error(e);
  }
}

export function childNodeAtIndexUnchecked(element, index) {
  console.log(`in childNode At Index unchecked element: ${element}, index:${index}`)
  if(element){
    return element.childNodes[index];
  }
  throw `${element} doesn't exist`
}

export function removeChild(element, child) {
  console.log("in remove child")
  element.removeChild(child);
}

export function replaceChild(parent, child, replacement) {
  console.log("in replace child")
  parent.replaceChild(child, replacement);
}

export function insertBefore(parent, child, before) {
  console.log("in insert before")
  console.log(`parent ${parent}, child ${child}, before ${before}`)
  if(parent){
    parent.insertBefore(child, before);
  }
  throw `${parent} is null in the insert before method`
}

export function childrenLength(parent) {
  if(parent){
    return parent.children.length;
  }
  // throw `${parent} doesn't exist in childrenLength`
  return 0;
}

export function setTextContent(element, text) {
  console.log("in setTextContent")
  element.textContent = text;
}

export function removeAttribute(element, key) {
  console.log("in removeAttribute")
  element.removeAttribute(key);
}

export function setAttribute(element, key, value) {
  console.log("in setAttribute")
  element.setAttribute(key, value);
}

export function outerHTML(element) {
  return element.outerHTML;
}

export function addEventListener(element, type, listener) {
  console.log("in addEventListener")
  element.addEventListener(type, listener);
}

export function removeEventListener(element, type, listener) {
  console.log("in remove event listener")
  element.removeEventListener(type, listener);
}
