<template>
  <section class="container flex flex-col max-h-full mx-auto">
    <div class="text-sm breadcrumbs">
      <ul>
        <li><a>Home</a></li>
      </ul>
    </div>
    <div class="float-right">
      <p>Filtrar por:</p>
      <select id="selectElement" class="w-full max-w-xs select select-bordered" multiple @change="onChangeInputMagTypes($event)">
        <option v-for="(mag, index) in magTypes" :value="mag" :key="`${index}-${mag}`">{{mag.toUpperCase()}}</option>
      </select>
    </div>
    <br>
    <div class="overflow-x-auto">
      <table class="table table-xs table-zebra">
        <!-- head -->
        <thead>
        <tr>
          <th>Id</th>
          <th>Title</th>
          <th>Place</th>
          <th>Mag Type</th>
        </tr>
        </thead>
        <tbody>
          <tr v-for="item in data.data" :key="item.attributes.external_id" class="hover" v-on:click="onSelectedItem(item)">
            <td>{{ item.attributes.external_id }}</td>
            <td>{{ item.attributes.title }}</td>
            <td>{{ item.attributes.place }}</td>
            <td>{{ item.attributes.mag_type }}</td>
          </tr>
        </tbody>
      </table>
    </div>
    <!-- Pagination -->
    <div class="float-right" v-if="$device.isDesktop">
      <b>Per Page</b>
      <select @change="onChangeInputPerPage($event)">
        <option value="20">20</option>
        <option value="40">40</option>
        <option value="80">80</option>
        <option value="100">100</option>
      </select>
      <b>Page</b>
      <select @change="onChangeInputPage($event)">
        <option v-for="(_, index) in Array(num_pages).fill(1)" :key="index" :value="index+1">
          {{ index + 1}}
        </option>
      </select>
    </div>
  </section>
</template>

<script setup lang="ts">
const route = useRoute()

class Pagination {
  total: number = 0;
  per_page: number = 20
  page: number = 1;
}
class JSONData {
  data: any[] = [];
  pagination: Pagination = {total: 0, per_page: 20, page: 1};
}

let selected: string[] = []
const magTypes = ["all", "md", "ml", "ms", "mw", "me", "mi", "mb", "mlg"]
let per_page = 20;
let page = 1
let pages = true
const {data: data, status} = await useFetch<JSONData>(`http://localhost:3000/api/features`)
console.log(data, status)

onMounted(async () => {
  console.log('onMounted')
  console.log("per_page -> ", data.value?.pagination.per_page)

});
console.log("Total -> ", data.value?.pagination.total)
let num_pages = Math.ceil(data.value?.pagination.total / data.value?.pagination.per_page)
console.log('Num Pages', num_pages)

async function onChangeInputPerPage(el: HTMLSelectElement) {
  console.log('onChangeInputPerPage', el.target.value, per_page)
  per_page = el.target.value
  await loadData({per_page, page})
}

async function onChangeInputPage(el: HTMLSelectElement) {
  console.log('onChangeInputPerPage', el.target.value, page)
  page = el.target.value
  await loadData({per_page, page})
}

async function onChangeInputMagTypes(el: HTMLSelectElement) {
  console.log('onChangeInputMagTypes', el.target.selectedOptions, selected)
  var options = el.target.selectedOptions
  var values = Array.from(options).map(({ value }) => value.toString());
  // filter all
  values = values.filter(item => item != 'all')
  console.log({ values })
  selected = values
  console.log({ selected })

  await loadData({per_page, page, magTypes: selected})
}

async function loadData({per_page, page, magTypes}: any) {
  let query = ''
  console.log({magTypes})
  let items: Array<string> = Array.from(magTypes)
  if (items.length >= 1) {
    // 1 filter or more
    items.forEach(item => query += `mag_type[]=${item}&`)
  } else if (magTypes.length == 0) {
    // all
  }
  console.log(query, magTypes)
  const {data: data2, status} = await useFetch<JSONData>(`http://localhost:3000/api/features?per_page=${per_page}&page=${page}&${query}`)

  data.value = data2.value
  num_pages = Math.ceil(data.value?.pagination.total / data.value?.pagination.per_page)
}

const onSelectedItem = async (item: any) => {
  console.log({ item })
  localStorage.setItem(item.id, JSON.stringify(item))
  await navigateTo({path: `/${item.id}`})
}

</script>