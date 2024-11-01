document.addEventListener("DOMContentLoaded", () => {
  const helpButton = document.getElementById("htp-help");
  const modal = document.getElementById("htp-modal");
  const playButton = document.getElementById("htp-play");

  helpButton?.addEventListener("click", () => {
    modal.style.display = "flex";
  });

  playButton?.addEventListener("click", () => {
    modal.style.display = "none";
  });

  // Close modal when clicking outside
  window.addEventListener("click", (event) => {
    if (event.target == modal) {
      modal.style.display = "none";
    }
  });

  document.addEventListener("keydown", handleKeyPress);
});

function handleKeyPress(event) {
  if (!["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"].includes(event.key))
    return;

  event.preventDefault();

  const direction = event.key.toLowerCase().replace("arrow", "");

  fetch("/game_2048/make_move", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content,
    },
    body: JSON.stringify({ direction }),
  })
    .then((response) => response.json())
    .then((data) => {
      updateBoard(data.board);
      updateScore(data.score);
      if (data.game_over) {
        document.getElementById("final-score").textContent = data.score;
        document.getElementById("game-over").style.display = "flex";
      }
    });
}

function updateBoard(board) {
  const cells = document.querySelectorAll(".board-cell");
  board.flat().forEach((value, index) => {
    const cell = cells[index];
    cell.className = `board-cell tile-${value}`;
    cell.textContent = value || "";
  });
}

function updateScore(score) {
  document.getElementById("score").textContent = score;
}
