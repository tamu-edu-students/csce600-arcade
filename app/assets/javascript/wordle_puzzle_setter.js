document.addEventListener("DOMContentLoaded", function() {
  // Wordle Update Dictionary modal parts
  const updateWordleDictModal = document.getElementById("updateWordleDictModal");
  const updateWordleDictClose = document.getElementById("updateWordleDictClose");
  const updateWordleDictBody = document.getElementById("updateWordleDictBody");

  // Wordle Update Dictionary Modal display control functions
  window.showUpdateWordleDict = function() {
    updateWordleDictModal.style.display = "block";
  }
  
  updateWordleDictClose.onclick = function() {
    updateWordleDictModal.style.display = "none";
    location.reload();
  }

  // close the modal is a user clicks outside of the modal anywhere else on the screen
  window.onclick = function(event) {
      if (event.target == updateWordleDictModal) {
        updateWordleDictModal.style.display = "none";
      }
  }

  // Wordle Puzzle Setter Search and Sort helpers
  window.toggleSearchAndSortOpts = function() {
    const searchAndSortContents = document.getElementById('searchAndSortContents');
    if (searchAndSortContents.style.display === 'block') {
      searchAndSortContents.style.display = 'none';
    } else {
      searchAndSortContents.style.display = 'block';
    }
  }

  window.searchAndSort = function() {
    const only_solutions = document.getElementById('only_solutions').checked;
    const word_part = document.getElementById('filter_wordle_dict').value;
    const sort_asc = document.getElementById('sort-a-z').checked;
    
    sendFetchRequest(`/wordle_dictionaries?only_solutions=${only_solutions}&word_part=${word_part}&sort_asc=${sort_asc}`, 'GET', {})
    .then ( response => {
      var word_list = "";
      for (let i = 0; i < response.words.length; i++) {
        word_list += response.words[i].word + '\n';
      }
      document.getElementById('wordle-word-list').value = word_list;
      console.log(`displayOnlyWordleSolutions resp:`, response);
    })

  }

  // Wordle Puzzle setter functions to allow updates to backend dictionary
  window.handleFileInputUpload = function() {
    document.getElementById('update-dict-wordle-errors').innerHTML = "";
    document.getElementById('wordle-tex-input').value = "";
    processFileInput()
    .then( newWords => {
      document.getElementById('wordle-tex-input').value = newWords;
      })
    .catch(error => {
      document.getElementById('update-dict-wordle-errors').className = "flash-message alert"
      document.getElementById('update-dict-wordle-errors').innerHTML = error;
      document.getElementById('wordle-tex-input').value = "";
      console.log('error processing file input');
    });
  }

  window.handleTextInputUpload = function() {
    document.getElementById('update-dict-wordle-errors').innerHTML = "";
    var newWords = document.getElementById('wordle-tex-input').value;
    const isValid = /^[a-zA-Z]{5}(\n[a-zA-Z]{5})*(\n)?$/.test(newWords);
    if (!isValid) {
      document.getElementById('update-dict-wordle-errors').className = "flash-message alert"
      document.getElementById('update-dict-wordle-errors').innerHTML = 'Error: Invalid textbox content format. Please fix issues and retry.';
      document.getElementById('file-upload').value = "";
    }
  }

  window.submitWordleDictUpdate = function() {
    document.getElementById('update-dict-wordle-errors').className = "flash-message info"
    document.getElementById('update-dict-wordle-errors').innerHTML = 'Processing update...';

    var newWords = document.getElementById('wordle-tex-input').value;
    if (newWords === null || newWords === undefined || newWords == '') {
      document.getElementById('update-dict-wordle-errors').className = "flash-message alert"
      document.getElementById('update-dict-wordle-errors').innerHTML = 'Error: No input provided.'
    }

    const params = {
      new_words: newWords,
      update_opt: (document.getElementById('add_words').checked) ? "add" : (document.getElementById('replace_words').checked) ? "replace" : "remove",
      valid_solutions: (document.getElementById('valid_solution').checked)
    }
    
    sendFetchRequest('/wordle_dictionaries/amend_dict', 'PATCH', params)
    .then ( response => {
      console.log(`submitWordleDictUpdate resp:`, response);
      if (response.success) {
        document.getElementById('update-dict-wordle-errors').className = "flash-message notice"
        document.getElementById('update-dict-wordle-errors').innerHTML = 'Update successful';
      } else {
        document.getElementById('update-dict-wordle-errors').className = "flash-message alert"
        document.getElementById('update-dict-wordle-errors').innerHTML = 'Update unsuccessful, please try again';
      }
    })
  }

  window.resetWords = function() {
    document.getElementById('update-dict-wordle-errors').className = "flash-message info"
    document.getElementById('update-dict-wordle-errors').innerHTML = 'Processing reset...';
    sendFetchRequest('/wordle_dictionaries/reset_dict', 'PATCH', {})
    .then ( response => {
      console.log(`resetWords resp:`, response);
      if (response.success) {
        document.getElementById('update-dict-wordle-errors').className = "flash-message notice"
        document.getElementById('update-dict-wordle-errors').innerHTML = 'Reset successful';
      } else {
        document.getElementById('update-dict-wordle-errors').className = "flash-message alert"
        document.getElementById('update-dict-wordle-errors').innerHTML = 'Reset unsuccessful, please try again';
      }
      
    })
  }

  // helper functions to make controller fetch calls easy
  const csrf = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  console.log(`csrf token: ${csrf}`);
  const headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
   ' X-CSRF-Token': csrf
  }

  function makeFetchRequest(method, params) {
    if (method == 'GET') {
      return {
        method: method,
        headers: headers
      }
    } else {
      return {
        method: method,
        headers: headers,
        body: JSON.stringify(params)
      }
    }
  }

  function sendFetchRequest(url, method, params) {
    return fetch(url, makeFetchRequest(method, params))
    .then(response => {
        return response.json();
    })
    .catch(error => {
      console.log(`fetch caught an error: ${error}`);
    });
  }
  
  function processFileInput() {
    const fileInput = document.getElementById('file-upload');

    if (fileInput.files.length === 0) {
      throw new Error('No file selected.');
    }

    const formData = new FormData();
    formData.append('file', fileInput.files[0]);

    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = function(event) {
            const fileContent = event.target.result;
            const isValid = /^[a-zA-Z]{5}(\n[a-zA-Z]{5})*(\n)?$/.test(fileContent);
            if (!isValid) {
              reject(new Error('Invalid file contents format. Please fix issues and retry.'));
            }
            resolve(fileContent);
        };
        reader.onerror = function(event) {
            reject(new Error('Error reading file: ' + event.target.error));
        };
        reader.readAsText(fileInput.files[0]);
    });
  }
})