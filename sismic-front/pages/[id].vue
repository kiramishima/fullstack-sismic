<template>
  <section class="container flex flex-col h-full max-h-full min-h-screen mx-auto">
    <ClientOnly>
      <div class="mb-10 text-sm breadcrumbs h-14">
        <ul>
          <li><NuxtLink to="/">Home</NuxtLink></li>
          <li><a>{{ item?.attributes?.external_id}}</a></li>
        </ul>
      </div>
      
      <div class="basis-full">
        <div v-if="item.attributes" class="w-2/3 shadow-xl card bg-base-100 sm:mx-auto">
          <div class="card-body">
            <h2>{{ item.attributes.title }}</h2>
            <p>Details</p>
            <span>
              <p>External ID: <span>{{ item.attributes.external_id }}</span></p>
              <p>Mag Type: <div class="badge badge-secondary">{{ item.attributes.mag_type }}</div></p>
              <p>Magnitude: <span>{{ item.attributes.magnitude }}</span></p>
              <p>Place: <a target="_blank" :href="item.links.external_url"><span>{{ item.attributes.place }}</span></a></p>
              <p>Tsunami: <span>{{ item.attributes.tsunami ? 'Yes' : 'No' }}</span></p>
            </span>
          </div>
        </div>
      </div>
      <br>
      <div class="flex sm:mx-auto">
        <p class="text-xl font-bold text-indigo-800">Comments</p>
        &nbsp;
        &nbsp;
        &nbsp;
        <button type="button" onclick="my_modal_1.showModal()">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v6m3-3H9m12 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
          </svg>
        </button>
      </div>

      <div class="flex-col flex-wrap h-auto mt-5 basis-full">
        <div class="flex-1">
          <div class="w-auto h-20 mb-5 card bg-base-100 drop-shadow-md" v-for="(comment, index) in data.data" :key="index">
            <div class="card-body">
              <blockquote>
                <p class="font-serif italic prose lg:prose-blockquotes">{{ comment.comment }}</p>
              </blockquote>
            </div>
          </div>
        </div>
      </div>

      <dialog id="my_modal_1" class="modal">
        <form @submit.prevent="onSubmit">
        <div class="modal-box">
          <h3 class="text-lg font-bold">Add comment</h3>
          <p class="py-4 text-xs">Press ESC key or click the button below to close</p>

            <div class="form-group">
              <textarea
                  class="w-full textarea textarea-primary"
                  placeholder="Write your comment here..."
                  v-model="comment"
              ></textarea>
              <p v-if="comment.trim() == ''" class="py-4 text-xs text-red-600">Comment must have a content.</p>
            </div>
          <div class="modal-action">
              <!-- if there is a button in form, it will close the modal -->
              <button type="submit" class="btn bg-primary-content" onclick="my_modal_1.close(false)">Submit</button>
              &nbsp;
              <button type="button" class="btn" onclick="my_modal_1.close(false)">Close</button>
          </div>


        </div>
        </form>
      </dialog>
    </ClientOnly>
  </section>
</template>

<script setup lang="ts">
const route = useRoute()
const id = route.params.id
let item: any | null = null
const comment = ref("")

if (process.client) {
  item = JSON.parse(localStorage.getItem(id))
}
onMounted(async () => {

  console.log(id)

  // item = JSON.parse(localStorage.getItem(id))
  console.log(item)
})

var data = await getCommentsData(id)

class CommentData {
  comment: string = ''
  created_at: Date = new Date()
}

async function getCommentsData(id: any) {
  // load comments
  const {data: data} = await useFetch<CommentData[]>(`http://localhost:3000/api/features/${id}/comments`)
  return data
}

async function onSubmit(e: HTMLFormElement) {
  // console.log({ comment })
  const {data: resp, status} = await useFetch<CommentData[]>(`http://localhost:3000/api/features/${id}/comments`, {
    method: 'POST',
    body: JSON.stringify({body: comment.value})
  })
  console.log({ resp })

  data = await getCommentsData(id)
}
</script>