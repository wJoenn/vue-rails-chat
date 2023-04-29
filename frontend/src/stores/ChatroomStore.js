import { defineStore } from "pinia"

const BACKEND_URL = "http://localhost:3000"

const useChatroomStore = defineStore("ChatroomStore", {
  state: () => ({
    chatrooms: [],
    chatroom: {
      id: null,
      messages: []
    }
  }),

  getters: {
    getChatrooms() {
      return this.chatrooms
    },

    getChatroomId() {
      return this.chatroom.id
    },

    getMessages() {
      return this.chatroom.messages
    }
  },

  actions: {
    async chatroomsIndex() {
      const res = await fetch(`${BACKEND_URL}/chatrooms`, {
        headers: { Authorization: localStorage.getItem("authToken") }
      })
      const data = await res.json()
      this.chatrooms = data
      this.chatroom.id = this.chatrooms[0].id
    },

    async updateChatroomId(id) {
      this.chatroom.id = id
      await this.messagesIndex()
    },

    async messagesIndex() {
      const res = await fetch(`${BACKEND_URL}/chatrooms/${this.getChatroomId}/messages`, {
        headers: { Authorization: localStorage.getItem("authToken") }
      })
      const data = await res.json()
      this.chatroom.messages = data
    },

    async messagesCreate(messageBody) {
      await fetch(`${BACKEND_URL}/chatrooms/${this.getChatroomId}/messages`, {
        method: "POST",
        headers: { Authorization: localStorage.getItem("authToken"), "Content-Type": "application/json" },
        body: JSON.stringify({ message: { content: messageBody } })
      })
    },

    addMessage(data) {
      this.chatroom.messages.push(data)
    }
  }
})

export default useChatroomStore
