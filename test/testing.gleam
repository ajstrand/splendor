import gleam_vdom/dom.{DOMElement}

pub external fn set_global(Bool) -> Nil =
  "./testing_ffi.mjs" "setGlobal"

pub external fn get_global() -> Bool =
  "./testing_ffi.mjs" "getGlobal"

pub external fn click(anything) -> Nil =
  "./testing_ffi.mjs" "click"

pub external fn child_node_at_index_unchecked(DOMElement, Int) -> DOMElement =
  "./dom_ffi.mjs" "childNodeAtIndexUnchecked"
