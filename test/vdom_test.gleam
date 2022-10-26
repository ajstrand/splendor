import gleam_vdom/vdom.{VDOM, element, text}
import gleam_vdom/dom.{DOMElement, by_id, get_query_selector, outer_html, patch}
import gleam_vdom/diff.{diff}
import gleam/option.{None, Some}
import gleam/io
import gleeunit
import gleeunit/should
import jsdom.{init}

pub fn main() {
  gleeunit.main()
}

pub fn container_test() {
  init()
  let container: DOMElement = get_query_selector("main")
  should.equal(outer_html(container), "<main>\n  </main>")
}

pub fn simple_state_test() {
  init()
  let container: DOMElement = get_query_selector("main")

  let initial_state: VDOM = element("p", [], [text("starting text")])

  patch(container, diff(new: Some(initial_state), old: None))
  // // None as there are no existing elements.
  should.equal(outer_html(container), "<main>\n  <p>starting text</p></main>")
  // "<div id=\"app\"><p>starting text</p></div>",
}
// pub fn base_test() {
//   init()
//   let container: DOMElement = get_query_selector("main")

//   let initial_state: VDOM = element("p", [], [text("starting text")])
//   let desired_state: VDOM = element("p", [], [text("new text!")])

//   dom.patch(container, diff(new: Some(desired_state), old: Some(initial_state)))

//   should.equal(
//     dom.outer_html(container),
//     "<div id=\"app\"><p>new text!</p></div>",
//   )
// }
