import { createApp } from "vue"
import { createPinia } from "pinia"

import { library } from "@fortawesome/fontawesome-svg-core"
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome"
import { faEyeSlash, faEye, faPaperPlane } from "@fortawesome/free-solid-svg-icons"

import App from "./App.vue"
import router from "./router/router"
import useSessionStore from "./stores/SessionStore"

const app = createApp(App)
const pinia = createPinia()
library.add(faEyeSlash, faEye, faPaperPlane)

// Load JWT from local storage on refresh

const authToken = localStorage.getItem("authToken")
const authTokenExists = authToken !== "undefined" && authToken !== null

if (authTokenExists) {
  await useSessionStore(pinia).loginUserWithToken(authToken)
}

app
  .component("FontAwesomeIcon", FontAwesomeIcon)
  .use(router)
  .use(pinia)
  .mount("#app")
