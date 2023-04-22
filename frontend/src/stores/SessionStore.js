import { defineStore } from "pinia"

const useSessionStore = defineStore("SessionStore", {
  state: () => ({
    auth_token: null,
    user: {
      id: null,
      username: null,
      email: null
    }
  }),
  actions: {

  }
})

export default useSessionStore
