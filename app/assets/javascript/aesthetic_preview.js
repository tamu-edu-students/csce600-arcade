document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("aesthetic-form");
  const previewDiv = document.getElementById("preview-board");

  form.addEventListener("change", function () {
    const formData = new FormData(form);
    const params = new URLSearchParams();

    formData.forEach((value, key) => {
      params.append(key, value);
    });

    fetch(form.action.replace("update", "preview"), {
      method: "PATCH",
      body: params,
      headers: {
        "X-Requested-With": "XMLHttpRequest",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    })
      .then((response) => response.text())
      .then((html) => {
        previewDiv.innerHTML = html;
      })
      .catch((error) => console.error("Error:", error));
  });
});
