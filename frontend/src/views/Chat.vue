<template>
  <div id="chat">
    <div class="left">
      <nav>
        <!-- eslint-disable-next-line max-len -->
        <button v-for="chatroom in chatroomStore.getChatrooms" :key="chatroom.id" @click="moveToChatroom(chatroom.id)">
          <span>#</span><span>{{ chatroom.name }}</span>
        </button>
      </nav>
      <router-link :to="{ name: 'Logout' }">Log out</router-link>
    </div>

    <div class="content">
      <div ref="messagesElement" class="messages">
        <!-- eslint-disable-next-line max-len -->
        <Message
          v-for="(message, index) in chatroomStore.getMessages"
          :key="message.id"
          :message="message"
          :last-message="(index === 0) ? null : chatroomStore.getMessages[index - 1]"
        />
      </div>

      <form @submit.prevent="messagesCreate">
        <textarea v-model="newMessage" rows="3" @keyup.enter.exact.prevent="messagesCreate" />
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
  const actionCableConsumer = createConsumer("ws://localhost:3000/cable")
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

    .left {
      background-color: #14141a;
      border-right: 1px solid #d3d3d359;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      width: 180px;

      a {
        border-radius: 5px;
        border-top: 1px solid #d3d3d359;
        color: $lightgrey-semi;
        font-size: 0.8rem;
        padding: 10px 20px;
        transition: color 0.3s ease;
        width: 100%;

        &:hover {
          color: $lightgrey;
        }
      }

      nav {
        display: flex;
        flex-direction: column;
        padding: 20px 10px;

        button {
          border-radius: 5px;
          color: $lightgrey-semi;
          display: flex;
          gap: 10px;
          padding: 0.25rem 0.5rem;
          transition: background-color 0.3s ease;
          width: 100%;

          &:hover {
            background-color: rgba(250, 250, 250, 0.1);
          }
        }
      }
    }

    .content {
      display: flex;
      flex-direction: column;
      flex-grow: 1;
      padding: 20px 0;

      form {
        background-color: #191d20;
        border: 1px solid $lightgrey-semi;
        border-radius: 10px;
        display: flex;
        flex-direction: column;
        flex-shrink: 0;
        gap: 5px;
        margin: 0 20px;
        overflow: hidden;
        padding: 10px;
        width: calc(100% - 40px);

        button {
          align-self: flex-end;
          color: $lightgrey-semi;
          font-size: 0.8rem;
          width: max-content;
        }

        textarea {
          background-color: transparent;
          border: none;
          color: inherit;
          font-family: inherit;
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
        margin: 0 5px 15px;
        padding: 0 15px;
        max-height: 100%;
        overflow: hidden;
        overflow-y: scroll;

        &:hover::-webkit-scrollbar-thumb {
          background-color: #d3d3d359;
          border-radius: 5px;
        }

        &::-webkit-scrollbar {
          width: 5px;
        }

        &::-webkit-scrollbar-thumb {
          background-color: transparent;
        }
      }
    }
  }
</style>
