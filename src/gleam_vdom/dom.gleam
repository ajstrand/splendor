//// Module for interfacing with the non-virtual DOM.

import gleam_vdom/vdom.{
  AEventListener, Attribute, Element, Text, VDOM, attribute_to_string,
}
import gleam_vdom/diff.{
  AttrDiff, ChildDiff, Delete, DeleteKey, Diff, Insert, InsertKey,
  RemoveEventListener, ReplaceText,
}
import gleam/list
import gleam/option.{None, Option, Some}
import gleam/io
import gleam/int
import gleam/iterator
import gleam/map
import gleam/string
import gleam/dynamic.{Dynamic}

/// Represents a DOM [Element](https://developer.mozilla.org/en-US/docs/Web/API/Element).
pub external type DOMElement

external fn create_text_node(String) -> DOMElement =
  "../dom_ffi.mjs" "createTextNode"

external fn create_element(String) -> DOMElement =
  "../dom_ffi.mjs" "createElement"

external fn append_child(DOMElement, DOMElement) -> Nil =
  "../dom_ffi.mjs" "appendChild"

external fn get_element_by_id(String) -> DOMElement =
  "../dom_ffi.mjs" "getElementById"

pub external fn get_query_selector(String) -> DOMElement =
  "../dom_ffi.mjs" "querySelector"

external fn child_node_at_index_unchecked(DOMElement, Int) -> DOMElement =
  "../dom_ffi.mjs" "childNodeAtIndexUnchecked"

external fn remove_child(DOMElement, DOMElement) -> Nil =
  "../dom_ffi.mjs" "removeChild"

external fn replace_child(DOMElement, DOMElement, DOMElement) -> Nil =
  "../dom_ffi.mjs" "replaceChild"

external fn insert_before(DOMElement, DOMElement, DOMElement) -> Nil =
  "../dom_ffi.mjs" "insertBefore"

external fn children_length(DOMElement) -> Int =
  "../dom_ffi.mjs" "childrenLength"

external fn set_text_content(DOMElement, String) -> Nil =
  "../dom_ffi.mjs" "setTextContent"

external fn remove_attribute(DOMElement, String) -> Nil =
  "../dom_ffi.mjs" "removeAttribute"

external fn set_attribute(DOMElement, String, String) -> Nil =
  "../dom_ffi.mjs" "setAttribute"

external fn add_event_listener(DOMElement, String, fn(Dynamic) -> Nil) -> Nil =
  "../dom_ffi.mjs" "addEventListener"

external fn remove_event_listener(DOMElement, String, fn(Dynamic) -> Nil) -> Nil =
  "../dom_ffi.mjs" "removeEventListener"

/// Returns the value of [outerHTML](https://developer.mozilla.org/en-US/docs/Web/API/Element/outerHTML)
/// for the provided `DOMElement`
pub external fn outer_html(DOMElement) -> String =
  "../dom_ffi.mjs" "outerHTML"

pub fn by_id(tag: String) {
  get_element_by_id(tag)
}

/// Creates a real DOM element from a virtual node; Including all of it's children.
pub fn create(node: VDOM) -> DOMElement {
  case node {
    Element(tag: tag, children: children, attributes: attributes) -> {
      let element = create_element(tag)
      attributes
      |> map.to_list()
      |> list.map(fn(key_pair: #(String, Attribute)) {
        case key_pair.1 {
          AEventListener(handler) ->
            add_event_listener(element, key_pair.0, handler)
          _ ->
            set_attribute(element, key_pair.0, attribute_to_string(key_pair.1))
        }
      })
      children
      |> list.map(create)
      |> list.map(fn(child) { append_child(element, child) })
      element
    }
    Text(value: value) -> create_text_node(value)
  }
}

/// Applies multiple `diff`s under a given element.
pub fn patch(parent: DOMElement, diff_list: List(Diff)) -> DOMElement {
  list.map(diff_list, fn(diff) { apply_diff(parent, diff) })
  parent
}

/// Applies a single  `diff` under a given element.
pub fn apply_diff(node: DOMElement, diff: Diff) -> DOMElement {
  case diff {
    Delete(index: index) -> {
      let child = child_node_at_index_unchecked(node, index)
      remove_child(node, child)
      node
    }
    Insert(index: index, vdom: vdom) -> {
      let child = create(vdom)
      let child_length = children_length(node)
      case index >= child_length {
        True -> {
          io.println("will append child")
          append_child(node, child)
        }
        False -> {
          io.println("will use insert before")
          insert_before(node, child, child_node_at_index_unchecked(node, index))
        }
      }
      node
    }
    ReplaceText(index: index, text: text) -> {
      let child = child_node_at_index_unchecked(node, index)
      set_text_content(child, text)
      node
    }
    ChildDiff(index: index, attr_diff: attr_diff_list, diff: diff_list) -> {
      let child = child_node_at_index_unchecked(node, index)
      list.map(
        attr_diff_list,
        fn(attr_diff) { apply_attribute_diff(child, attr_diff) },
      )
      list.map(diff_list, fn(diff) { apply_diff(child, diff) })
      node
    }
  }
}

fn apply_attribute_diff(node: DOMElement, attr_diff: AttrDiff) {
  case attr_diff {
    DeleteKey(key: key) -> remove_attribute(node, key)
    InsertKey(key: key, attribute: attribute) ->
      case attribute {
        AEventListener(handler) -> add_event_listener(node, key, handler)
        _ -> set_attribute(node, key, attribute_to_string(attribute))
      }
    RemoveEventListener(key: key, handler: handler) ->
      remove_event_listener(node, key, handler)
  }
}
