<template>
  <div id="chat">
    <div class="left">
      <nav>
        <!-- eslint-disable-next-line max-len -->
        <button v-for="chatroom in chatroomStore.getChatrooms" :key="chatroom.id" @click="moveToChatroom(chatroom.id)">
          #{{ chatroom.name }}
        </button>
      </nav>
      <router-link :to="{ name: 'Logout' }">Log out</router-link>
    </div>

    <div class="content">
      <div ref="messagesElement" class="messages">
        <Message v-for="message in chatroomStore.getMessages" :key="message.id" :message="message" />
      </div>

      <form @submit.prevent="messagesCreate">
        <textarea v-model="newMessage" rows="5" @keyup.enter.exact.prevent="messagesCreate" />
        <button><FontAwesomeIcon icon="fa-solid fa-paper-plane" class="send" /></button>
      </form>
    </div>
  </div>
</template>

<script setup>
  import { ref, nextTick, onBeforeUnmount, onMounted } from "vue"
  import { createConsumer } from "@rails/actioncable"

  import useChatroomStore from "../stores/ChatroomStore"
  import Message from "../components/Message.vue"

  const chatroomStore = useChatroomStore()
  const actionCableConsumer = createConsumer(import.meta.env.VITE_CHANNEL_URL)
  let channel

  const messagesElement = ref(null)
  const newMessage = ref("")

  const scrollDown = () => {
    nextTick(() => {
      messagesElement.value.lastElementChild.scrollIntoView()
    })
  }

  const addMessage = data => {
    chatroomStore.addMessage(data)
    scrollDown()
  }

  const subscribeToChannel = () => {
    channel = actionCableConsumer.subscriptions.create(
      { channel: "ChatroomChannel", id: chatroomStore.getChatroomId },
      { received: data => addMessage(data) }
    )
  }

  const messagesCreate = async () => {
    await chatroomStore.messagesCreate(newMessage.value)

    newMessage.value = ""
  }

  const moveToChatroom = async id => {
    await chatroomStore.updateChatroomId(id)
    scrollDown()
    channel.unsubscribe()
    subscribeToChannel()
  }

  onMounted(async () => {
    await chatroomStore.chatroomsIndex()
    await chatroomStore.messagesIndex()

    scrollDown()

    subscribeToChannel()
  })

  onBeforeUnmount(() => channel.unsubscribe())
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

    .left {
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

      nav {
        align-items: flex-start;
        display: flex;
        flex-direction: column;
        gap: 10px;
      }
    }

    .content {
      display: flex;
      flex-direction: column;
      flex-grow: 1;
      padding: 20px 0;

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
        margin: 0 5px 30px;
        padding: 0 15px;
        max-height: 100%;
        overflow: hidden;
        overflow-y: scroll;

        &::-webkit-scrollbar {
          width: 2px;
        }

        &::-webkit-scrollbar-thumb {
          background-color: #11242e;
          border-radius: 50%;
        }
      }
    }
  }
</style>
