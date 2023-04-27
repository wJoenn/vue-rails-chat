<template>
  <div :class="{ own: message.user_id === sessionStore.getUserId, message: true }">
    <div>
      <h3 v-if="lastMessage === null || isDifferrentUser">{{ message.username }}</h3>
      <span v-if="lastMessage === null || isDifferrentTime || isDifferrentUser">
        {{ formatDate(message.created_at) }}
      </span>
    </div>

    <p>{{ message.content }}</p>
  </div>
</template>

<script setup>
  import { toRef } from "vue"
  import useSessionStore from "../stores/SessionStore"

  const props = defineProps({
    message: Object,
    lastMessage: Object
  })

  const sessionStore = useSessionStore()
  const message = toRef(props, "message")
  const lastMessage = toRef(props, "lastMessage")

  const formatDate = date => {
    const formattedDate = new Date(date)
      .toLocaleTimeString("en-US", { hour: "2-digit", minute: "2-digit" })
      .replace(" ", "")
      .toLowerCase()

    return formattedDate
  }

  const isDifferrentUser = lastMessage.value === null || lastMessage.value.username !== message.value.username
  const isDifferrentTime = lastMessage.value === null
    || formatDate(lastMessage.value.created_at) !== formatDate(message.value.created_at)
</script>

<style lang="scss" scoped>
  .message {
    font-size: 0.8rem;
    margin: 5px 0;
    width: 100%;

    div {
      align-items: center;
      display: flex;
      gap: 10px;

      span {
        color: $lightgrey-semi;
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
</style>
