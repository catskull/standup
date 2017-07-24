<template>
  <div class="card">
    <el-card class="box-card" :class="status">
    <div slot="header" class="clearfix">
      <h2>{{name}}</h2>
      <p class="status">is {{status}}</p>
      <p class="status updated">{{timeAgo}}</p>
    </div>
  </el-card>
  </div>
</template>

<script>
import moment from 'moment'

export default {
  name: 'card',

  props: ['name', 'status', 'timestamp'],

  data () {
    return {
      timeAgo: ''
    }
  },

  created () {
    this.timeAgo = moment(this.timestamp).fromNow()
    if (this.timeAgo === 'a few seconds ago') {
      this.timeAgo = 'just now'
    }
  }
}
</script>

<style scoped>
  h2 {
    line-height: 36px;
    display: inline;
    font-weight: 400;
  }

  .box-card {
    margin-bottom: 10px;
  }

  .standing {
    border-color: #20A0FF;
  }

  .sitting {
    border-color: #F7BA2A;
  }

  .status {
    margin: 0;
    color: #8492A6;
    display: inline;
  }

  .updated {
    float: right;
    margin-top: 16px;
    font-size: 13px;
  }
</style>
