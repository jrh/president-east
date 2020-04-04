<template>
  <div>
    <b-row align-h="center" class="mt-5">
      <p style="font-size: 24px">My Profile</p>
    </b-row>
    <b-row align-h="center" class="my-5">
      <b-avatar size="72px"></b-avatar>
    </b-row>
  </div>
</template>

<script>
import Button from './shared/Button';

export default {
  name: 'UserProfile',
  components: { Button },
  data() {
    return {
      userId: Number(this.$route.params.id),
      alertShow: false,
      alertVariant: null,
      alertMessage: '',
      processing: false,

    }
  }
}
</script>
