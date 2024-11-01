document.addEventListener("DOMContentLoaded", function() {
    const wordModal = document.getElementById("wordModal");
    const wordModalClose = document.getElementById("wordModalClose");
    const wordModalBody = document.getElementById("wordModalBody");

    const addWordsModal = document.getElementById("addWordsModal");
    const addWordsClose = document.getElementById("addWordsClose");
    const addWordsModalBody = document.getElementById("addWordsModalBody");

    window.showWord = function(wordId) {
        fetch(`/wordle_valid_solutions/${wordId}`)
        .then(response => response.text())
        .then(data => {
          wordModalBody.innerHTML = data;
          wordModal.style.display = "block";
        })
        .catch(error => console.error("Error fetching word details:", error));
    }

    window.editWord = function(wordId) {
        fetch(`/wordle_valid_solutions/${wordId}/edit`)
        .then(response => response.text())
        .then(data => {
          wordModalBody.innerHTML = data;
          wordModal.style.display = "block";
        })
        .catch(error => console.error("Error fetching word details:", error));
    }

    window.deleteWord = function(wordId) {
        fetch(`/wordle_valid_solutions/${wordId}`, {
            method: "DELETE",
            headers: {
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
          })
        .then(response => response.text())
        .then(data => {
          wordModalBody.innerHTML = "Word successfully deleted!";
          wordModal.style.display = "block";
        })
        .catch(error => {
          wordModalBody.innerHTML = `Error deleting word: ${error}`;
        });
    }

    window.submitWordleValidSolutionForm = function(wordId) {
        const word = document.getElementById("wordle-word").value;
    
        fetch(`/wordle_valid_solutions/${wordId}`, {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          },
          body: JSON.stringify({ word: word })
        })
        .then(response => {
          if (response.ok) {
            return response.json();
          } else {
            throw new Error('Server response was not ok.');
          }
        })
        .then(data => {
          wordModalBody.innerHTML = showWord(wordId);
        })
        .catch(error => {
          wordModalBody.innerHTML = `Error updating word: ${error}`;
        });
      }

      wordModalClose.onclick = function() {
        wordModal.style.display = "none";
        location.reload();
      }

      

  window.processFileAddSolutionsWordSubmit = function() {
    const fileInput = document.getElementById('file-upload-add');
    const modalBody = document.getElementById("addWordsModalBody");

    processFileInput(fileInput)
    .then( newWords => {
      return fetch('/wordle_valid_solutions/add_solutions', {
        method: 'PATCH',
        body: JSON.stringify({ new_words_solutions: newWords }),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        }
      })
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        } else {
            throw new Error('Server response was not ok.');
        }
    })
    .then(data => {
        modalBody.innerHTML = "Words added successfully!";
    })
    .catch(error => {
        modalBody.innerHTML = `Error adding words: ${error}`;
    });
  }

  window.processTextAddSolutionsWordSubmit = function() {
    const inputField = document.getElementById('new-words-add');
    const modalBody = document.getElementById("addWordsModalBody");
    const newWords = inputField.value.split(',').map(word => word.trim());

    fetch('/wordle_valid_solutions/add_solutions', {
        method: 'PATCH',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({ new_words_solutions: newWords })
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        } else {
          return response.json().then(err => {
            throw new Error(err.errors.join(', '));
          });
        }
    })
    .then(data => {
        modalBody.innerHTML = "Words added successfully!";
    })
    .catch(error => {
        modalBody.innerHTML = `Error adding words: ${error}`;
    });
  }

  window.processFileOverwriteSolutionsWordSubmit = function() {
    const fileInput = document.getElementById('file-upload-replace');
    const modalBody = document.getElementById("addWordsModalBody");

    processFileInput(fileInput)
    .then(newWords => {
      return fetch('/wordle_valid_solutions/overwrite_solutions', {
        method: 'PATCH',
        body: JSON.stringify({ new_words_solutions: newWords }),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        }
      })
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        } else {
          return response.json().then(err => {
            throw new Error(err.errors.join(', '));
          });
        }
    })
    .then(data => {
        modalBody.innerHTML = "Words overwritten successfully!";
    })
    .catch(error => {
        modalBody.innerHTML = `Error overwriting words: ${error}`;
    });
  }

  window.processTextOverwriteSolutionsWordSubmit = function() {
    const inputField = document.getElementById('new-words-replace');
    const modalBody = document.getElementById("addWordsModalBody");
    const newWords = inputField.value.split(',').map(word => word.trim());

    fetch('/wordle_valid_solutions/overwrite_solutions', {
        method: 'PATCH',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({ new_words_solutions: newWords })
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        } else {
          return response.json().then(err => {
            throw new Error(err.errors.join(', '));
          });
        }
    })
    .then(data => {
        modalBody.innerHTML = "Words overwritten successfully!";
    })
    .catch(error => {
        modalBody.innerHTML = `Error overwriting words: ${error}`;
    });
  }

  window.resetWords = function() {
    const modalBody = document.getElementById("addWordsModalBody");

    fetch('/wordle_valid_solutions/reset_solutions', {
        method: 'PATCH',
        headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        }
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        } else {
          return response.json().then(err => {
            throw new Error(err.errors.join(', '));
          });
        }
    })
    .then(data => {
        modalBody.innerHTML = "Words reset to default successfully!";
    })
    .catch(error => {
        modalBody.innerHTML = `Error resetting words: ${error}`;
    });
  }
  
  function processFileInput(fileInput) {
    if (fileInput.files.length === 0) {
      throw new Error('No file selected.');
    }
    const formData = new FormData();
    formData.append('file', fileInput.files[0]);

    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = function(event) {
            const fileContent = event.target.result;
            const wordsArray = fileContent.split('\n').map(word => word.trim()).filter(word => word);
            resolve(wordsArray);
        };
        reader.onerror = function(event) {
            reject(new Error('Error reading file: ' + event.target.error));
        };
        reader.readAsText(fileInput.files[0]);
    });
  }

  window.addWordsInput = function() {
    addWordsModal.style.display = "block";
  }
  
  addWordsClose.onclick = function() {
    addWordsModal.style.display = "none";
    location.reload();
  }

  window.onclick = function(event) {
      if (event.target == addWordsModal) {
        addWordsModal.style.display = "none";
      }
      if (event.target == wordModal) {
        wordModal.style.display = "none";
      }
  }
})