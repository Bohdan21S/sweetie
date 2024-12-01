// document.addEventListener("DOMContentLoaded", () => {
//     document.querySelectorAll(".update-quantity").forEach((button) => {
//         button.addEventListener("click", (event) => {
//             const action = event.target.dataset.action;
//             const itemId = event.target.dataset.item_id;
//             const quantityField = document.querySelector(
//                 `.quantity-field[data-item-id='${itemId}']`
//             );
//
//             let quantity = parseInt(quantityField.value, 10) || 1;
//
//             if (action === "increase") {
//                 quantity += 1;
//             } else if (action === "decrease" && quantity > 1) {
//                 quantity -= 1;
//             }
//
//             quantityField.value = quantity;
//
//             // Автоматично надсилати форму
//             quantityField.closest("form").querySelector("input[type='submit']").click();
//         });
//     });
// });
