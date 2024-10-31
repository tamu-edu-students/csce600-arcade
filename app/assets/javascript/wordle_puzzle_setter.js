document.addEventListener("DOMContentLoaded", function() {
    const modal = document.getElementById("wordModal");
    const closeBtn = document.getElementsByClassName("close")[0];
    const modalBody = document.getElementById("modal-body");

    window.showWord = function(wordId) {
        fetch(`/wordle_valid_solutions/${wordId}`)
        .then(response => response.text())
        .then(data => {
            modalBody.innerHTML = data;
            modal.style.display = "block";
        })
        .catch(error => console.error("Error fetching word details:", error));
    }

    window.editWord = function(wordId) {
        fetch(`/wordle_valid_solutions/${wordId}/edit`)
        .then(response => response.text())
        .then(data => {
            modalBody.innerHTML = data;
            modal.style.display = "block";
        })
        .catch(error => console.error("Error fetching word details:", error));
    }

    window.deleteWord = function(wordId) {
        fetch(`/wordle_valid_solutions/${wordId}`, { method: "DELETE" })
        .then(response => response.text())
        .then(data => {
            modalBody.innerHTML = data;
            modal.style.display = "block";
        })
        .catch(error => console.error("Error fetching word details:", error));
    }

    closeBtn.onclick = function() {
        modal.style.display = "none";
    }

    window.onclick = function(event) {
        if (event.target == modal) {
        modal.style.display = "none";
        }
    }

    window.submitWordleValidSolutionForm = function(wordId) {
        const modalBody = document.getElementById("modal-body");
        const word = document.getElementById("wordle-word").value;
        console.log('NANU');
        console.log(wordId);
    
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
            throw new Error('Network response was not ok.');
          }
        })
        .then(data => {
          modalBody.innerHTML = "<%= j render 'wordle_valid_solution', wordle_valid_solution: @wordle_valid_solution %>";
          const notice = data.notice || 'Word updated successfully!';
          if (notice) {
            const noticeElement = document.createElement("div");
            noticeElement.className = "flash-notice";
            noticeElement.innerText = notice;
            modalBody.prepend(noticeElement);
          }
        })
        .catch(error => {
          console.error("Error updating wordle valid solution:", error);
          modalBody.innerHTML = "An error occurred. Please try again.";
        });
      }
      
})