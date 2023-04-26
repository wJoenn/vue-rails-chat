<template>
  <div id="chat">
    <nav>
      <button v-for="chatroom in chatrooms" :key="chatroom.id">#{{ chatroom.name }}</button>
      <router-link :to="{ name: 'Logout' }">Log out</router-link>
    </nav>

    <div class="content">
      <div class="messages">
        <div
          v-for="message in messages"
          :key="message.id"
          class="message"
          :class="{ own: message.user_id === sessionStore.getUserId }"
        >
          <div>
            <h3>{{ message.username }}</h3>
            <span>{{ message.created_at }}</span>
          </div>

          <p>{{ message.content }}</p>
        </div>
      </div>

      <form @submit.prevent="messageCreate">
        <textarea v-model="newMessage" rows="5" />
        <button><FontAwesomeIcon icon="fa-solid fa-paper-plane" class="send" /></button>
      </form>
    </div>
  </div>
</template>

<script setup>
  import { ref, onMounted } from "vue"
  import moment from "moment"
  import useSessionStore from "../stores/SessionStore"

  const sessionStore = useSessionStore()
  const chatrooms = ref([])
  const currentChatroom = ref(null)
  const messages = ref([])
  const newMessage = ref("")
  const url = import.meta.env.VITE_BACKEND_URL

  const messageCreate = async () => {
    await fetch(`${url}/chatrooms/${currentChatroom.value}/messages`, {
      method: "POST",
      headers: { Authorization: localStorage.getItem("authToken"), "Content-Type": "application/json" },
      body: JSON.stringify({ message: { content: newMessage.value } })
    })

    newMessage.value = ""
  }

  const fetchChatrooms = async () => {
    const res = await fetch(`${url}/chatrooms`, { headers: { Authorization: localStorage.getItem("authToken") } })
    const data = await res.json()
    chatrooms.value = data
    currentChatroom.value = chatrooms.value[0].id
  }

  const fetchMessages = async () => {
    const res = await fetch(`${url}/chatrooms/${currentChatroom.value}/messages`, {
      headers: { Authorization: localStorage.getItem("authToken") }
    })
    const data = await res.json()
    messages.value = data
    messages.value = messages.value.map(message => {
      message.created_at = moment(message.created_at).fromNow()
      return message
    })
  }

  onMounted(async () => {
    await fetchChatrooms()
    await fetchMessages()
  })
</script>

<style lang="scss" scoped>
  #chat {
    display: flex;
    height: 100vh;
    overflow: hidden;
    width: 100vw;

    button {
      background-color: transparent;
      border: none;
      color: inherit;
      cursor: pointer;
    }

    nav {
      align-items: flex-start;
      background-color: #11101d;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
      display: flex;
      flex-direction: column;
      flex-shrink: 0;
      justify-content: space-between;
      padding: 20px;
      width: 200px;

      button {
        font-size: 20px;
      }
    }

    .content {
      display: flex;
      flex-direction: column;
      flex-grow: 1;
      padding: 20px;

      form {
        background-color: #181a1b;
        border: 1px solid #d3d3d380;
        border-radius: 10px;
        display: flex;
        flex-direction: column;
        flex-shrink: 0;
        gap: 5px;
        overflow: hidden;
        padding: 10px;
        width: 100%;

        button {
          align-self: flex-end;
          font-size: 0.8rem;
          width: max-content;
        }

        textarea {
          background-color: transparent;
          border: none;
          color: inherit;
          resize: none;

          &:focus {
            outline: none;
          }
        }
      }

      .messages {
        display: flex;
        flex-direction: column;
        flex-grow: 1;
        justify-content: flex-end;
        margin-bottom: 30px;

        .message {
          margin: 10px 0;
          width: 100%;

          div {
            align-items: center;
            display: flex;
            font-size: 12px;
            gap: 10px;

            span {
              color: #e3e3e380;
              font-size: 0.8em;
            }
          }
        }

        .own {
          text-align: right;

          div {
            justify-content: flex-end;
          }
        }
      }
    }
  }
</style>
