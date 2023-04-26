<template>
  <div id="chat">
    <nav>
      <button v-for="chatroom in chatrooms" :key="chatroom.id">#{{ chatroom.name }}</button>
    </nav>

    <div class="content">
      <div class="messages">
        <div v-for="message in messages" :key="message.id">
          {{ message.content }}
        </div>
      </div>

      <form>
        <textarea v-model="newMessage" rows="5" />
        <FontAwesomeIcon icon="fa-solid fa-paper-plane" class="send" />
      </form>
    </div>
  </div>
</template>

<script setup>
  import { ref } from "vue"

  const chatrooms = ref([])
  const messages = ref([])
  const newMessage = ref("")

  const url = import.meta.env.VITE_BACKEND_URL
  fetch(`${url}/chatrooms`, {
    headers: { Authorization: localStorage.getItem("authToken") }
  }).then(res => res.json())
    .then(data => {
      chatrooms.value = data
    })
</script>

<style lang="scss" scoped>
  #chat {
    display: flex;
    height: 100vh;
    overflow: hidden;
    width: 100vw;

    nav {
      background-color: #11101d;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
      flex-shrink: 0;
      padding: 20px;
      width: 200px;

      button {
        background-color: transparent;
        border: none;
        color: inherit;
        cursor: pointer;
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

        textarea {
          background-color: transparent;
          border: none;
          color: inherit;
          resize: none;

          &:focus {
            outline: none;
          }
        }

        .send {
          align-self: flex-end;
          cursor: pointer;
          font-size: 0.8rem;
        }
      }

      .messages {
        flex-grow: 1;
      }
    }
  }
</style>
