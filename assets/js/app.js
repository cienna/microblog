// code below references NuMart code

// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket";

let handlebars = require("handlebars");

$(function() {
  if($("#feed-page")[0]) {
    var chan;
//    let bs = document.querySelector("#submit-button");
    let feedContainer = document.querySelector("#feed");
    let form = document.querySelector("form");

    join_channel();

//    let bs = $($("#submit-button")[0]);

    form.addEventListener("submit", send_post_update, {passive: true});

    function send_post_update(event){
      console.log(event.toString());
      chan.push("new_post", {body: event.toString()});
      console.log("pushed");
    };

    function join_channel() {
      chan = socket.channel("feed:lobby", {});
      chan.join()
        .receive("ok", resp => { console.log("Joined successfully", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) });

      chan.on("new_post", payload => {
        let postItem = document.createElement("div", {class: "row"});
        /*  let divCol = document.createElement("div", {class: "col-md-12"});
         let divCard = document.createElement("div", {class: "card my-2 mx-auto", style: "width: 30rem;"});
         let cardBody = document.createElement("div", {class: "card-body"});
         let cardText = document.createElement("p", {class: "card-text"})

         cardText.innerText = `${payload.body}`
         cardBody.innerText = cardText
         divCard.innerText = cardBody
         divCol.innerText = divCard
         postItem.innerText = divCol
 */

        postItem.innerText =`${payload.body}`;

        feedContainer.insertBefore(postItem, feedContainer.firstChild);
      });
    }

//    function feed_update() {
//      console.log("feed");
//    }

//    bs.click(feed_update);
  }
  else if ($("#likes-template").length > 0) {
    console.log("like button branch");

    let tt = $($("#likes-template")[0]);
    let code = tt.html();
    let tmpl = handlebars.compile(code);

    let dd = $($("#post-likes")[0]);
    let path = dd.data('path');
    let p_id = dd.data('post_id');

    let ba = $($("#like-button")[0]);
    let u_id = ba.data('user-id');

    function fetch_likes() {
      function got_likes(data) {
        let html = tmpl(data);
        dd.html(html);
      }

      $.ajax({
        url: path,
        data: {post_id: p_id},
        contentType: "application/json",
        dataType: "json",
        method: "GET",
        success: got_likes,
      });
    }

    function add_like() {
      let data = {like: {post_id: p_id, user_id: u_id}};
      $.ajax({
        url: path,
        data: JSON.stringify(data),
        contentType: "application/json",
        dataType: "json",
        method: "POST",
        success: fetch_likes,
      });

      $("#like-button").hide();
      $("#liked-button").show();
    }

    ba.click(add_like);

    fetch_likes();
  }
  else {
    // not the page I want
    console.log("no ajax");
    return;
  }
});

