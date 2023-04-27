<template>
  <div :class="{ own: message.user_id === sessionStore.getUserId, message: true }">
    <div>
      <h3>{{ message.username }}</h3>
      <span>{{ message.created_at }}</span>
    </div>

    <p>{{ message.content }}</p>
  </div>
</template>

<script setup>
  import { toRef } from "vue"
  import useSessionStore from "../stores/SessionStore"

  const props = defineProps({
    message: Object
  })

  const sessionStore = useSessionStore()
  const message = toRef(props, "message")
</script>

<style lang="scss" scoped>
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
</style>
