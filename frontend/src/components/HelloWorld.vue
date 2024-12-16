<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
  </div>
  <h2 v-if="greeting">{{ greeting }}</h2>
  <button @click="fetchData">Click Me!</button>
</template>

<script>
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data() {
    return {
      greeting: "",
    };
  },
  methods: {
    fetchData() {
      fetch('http://localhost:8888/greeting/fk', {
        method: "GET",
      })
        .then((response) => {
          response.json().then((data) => {
            this.greeting = data.message;
          });
        })
        .catch((err) => {
          console.error(err);
        });
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
