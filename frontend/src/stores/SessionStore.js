import { defineStore } from "pinia"

const useSessionStore = defineStore("SessionStore", {
  state: () => ({
    auth_token: null,
    user: {
      id: null,
      email: null,
      username: null
    }
  }),
  getters: {
    getAuthToken() {
      return this.auth_token
    },

    getUserEmail() {
      return this.user.email
    },

    getUserId() {
      return this.user.id
    },

    getUserUsername() {
      return this.user.username
    },

    isLoggedIn() {
      const loggedOut = this.auth_token === null || this.auth_token === JSON.stringify(null)

      return !loggedOut
    }
  }
})

export default useSessionStore
