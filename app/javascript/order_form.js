// alert("JS FOR ORDER FORM WORKING");
//
// document.addEventListener("DOMContentLoaded", () => {
//     const deliveryMethod = document.getElementById("order_delivery_method");
//     const pickupOptions = document.getElementById("pickup-options");
//     const novaPoshtaOptions = document.getElementById("nova-poshta-options"); // for div element
//
//     // Перевірка на існування всіх елементів
//     if (!deliveryMethod) {
//         console.error("Елемент delivery-method не знайдено. Перевірте HTML.");
//         return;
//     }
//     console.log("Елемент delivery-method знайдено:", deliveryMethod);
//
//     if (!novaPoshtaOptions) {
//         console.error("Елементи для відображення опцій доставки новою поштою не знайдено. Перевірте HTML.");
//         return;
//     } else {
//         console.log("NOVA POSHTA " + novaPoshtaOptions);
//     }
//
//     // Функція для відображення відповідних полів доставки
//     const toggleDeliveryOptions = () => {
//         console.log("Зміна способу доставки:", deliveryMethod.value);
//
//         if (deliveryMethod.value === "Самовивіз") {
//             pickupOptions.style.display = "block";
//             novaPoshtaOptions.style.display = "none";
//         } else if (deliveryMethod.value === "Нова Пошта") {
//             pickupOptions.style.display = "none";
//             novaPoshtaOptions.style.display = "block";
//         } else {
//             pickupOptions.style.display = "none";
//             novaPoshtaOptions.style.display = "none";
//         }
//     };
//
//     // Викликаємо функцію для початкового відображення
//     toggleDeliveryOptions();
//
//     // Відслідковуємо зміну способу доставки
//     deliveryMethod.addEventListener("change", toggleDeliveryOptions);
// });


// alert("JS FOR ORDER FORM WORKING");

document.addEventListener("DOMContentLoaded", () => {
    const deliveryMethod = document.getElementById("order_delivery_method");
    const pickupOptions = document.getElementById("pickup-options");
    const novaPoshtaOptions = document.getElementById("nova-poshta-options");
    const cityInput = document.getElementById("city-input");
    const branchesSelect = document.getElementById("order_nova_poshta_branch");

    const citySuggestions = document.getElementById("city-suggestions");


    // Перевірка на існування ключових елементів
    if (!deliveryMethod || !pickupOptions || !novaPoshtaOptions) {
        console.error("Не всі необхідні елементи знайдено. Перевірте HTML.");
        return;
    }

    if (!branchesSelect) {
        console.error("branchesSelect branchesSelect branchesSelect");
        return;
    }

    console.log("Елементи для управління формою знайдено.");

    // Функція для відображення відповідних опцій доставки
    const toggleDeliveryOptions = () => {
        console.log("Зміна способу доставки:", deliveryMethod.value);

        if (deliveryMethod.value === "Самовивіз") {
            pickupOptions.style.display = "block";
            novaPoshtaOptions.style.display = "none";
        } else if (deliveryMethod.value === "Нова Пошта") {
            pickupOptions.style.display = "none";
            novaPoshtaOptions.style.display = "block";
        } else {
            pickupOptions.style.display = "none";
            novaPoshtaOptions.style.display = "none";
        }
    };

    // Викликаємо функцію для початкового відображення
    toggleDeliveryOptions();

    // Відслідковуємо зміну способу доставки
    deliveryMethod.addEventListener("change", toggleDeliveryOptions);

    // Завантаження відділень Нової Пошти при введенні міста
    let lastSelectedCity = ''; // Змінна для збереження останнього вибраного міста

    // для обробки автозаповнення
    const loadBranches = async (city) => {
        if (!city || !branchesSelect) {
            console.error("Місто не вказано або відсутній елемент branchesSelect.");
            return;
        }

        console.log(`Завантаження відділень для міста: ${city}`);
        try {
            // Відправляємо запит до контролера
            const response = await fetch(`/nova_poshta/branches?city=${city}`);
            if (!response.ok) {
                throw new Error(`HTTP помилка! Статус: ${response.status}`);
            }

            const branches = await response.json();
            console.log("Відділення отримано:", branches);

            // Очищуємо старі опції
            branchesSelect.innerHTML = '<option value="">Оберіть відділення</option>';

            // Додаємо нові опції
            branches.forEach(branch => {
                const option = document.createElement("option");
                option.value = branch;
                option.textContent = branch;
                branchesSelect.appendChild(option);
            });
        } catch (error) {
            console.error("Помилка при завантаженні відділень:", error);
        }
    };


    // ставимо затримку виконання методу для кейсу вибору автозаповнення міста,
    // щоб спочатку виконався метод кліку автозаповлення та переприсвоїлося значення lastSelectedCity
    cityInput.addEventListener("blur", () => {
        console.log("    cityInput.addEventListener(\"blur\", () => {");
        setTimeout(() => {
            const city = cityInput.value.trim();
            if (city && city !== lastSelectedCity) {
                lastSelectedCity = city; // Оновлюємо останнє вибране місто
                loadBranches(city);
            } else {
                console.log("Місто не змінилося або не введено. Запит не виконується.");
            }
        }, 124);
    });


    // Пошук міст
    cityInput.addEventListener("input", async () => {
        const query = cityInput.value.trim();
        if (query.length >= 2) {
            try {
                const response = await fetch(`/nova_poshta/cities?query=${query}`);
                const cities = await response.json();

                // Відображення списку міст
                citySuggestions.innerHTML = '';
                cities.forEach(city => {
                    const li = document.createElement("li");
                    li.textContent = city;
                    li.style.cursor = "pointer";
                    li.addEventListener("click", () => {
                        cityInput.value = city;
                        lastSelectedCity = city;
                        citySuggestions.style.display = "none";
                        loadBranches(city); // Завантаження відділень для вибраного міста
                    });
                    citySuggestions.appendChild(li);
                });

                citySuggestions.style.display = "block";
            } catch (error) {
                console.error("Помилка завантаження міст:", error);
            }
        } else {
            citySuggestions.style.display = "none";
        }
    });


    // Обробка оплати картою на сайті
    const paymentMethod = document.getElementById("order_payment_method");
    const cardDetails = document.getElementById("card-details");

    if (!paymentMethod || !cardDetails) {
        console.error("Елементи для управління полем карти не знайдено.");
        return;
    }

    const toggleCardDetails = () => {
        if (paymentMethod.value === "Карта на сайті") {
            cardDetails.style.display = "block";
        } else {
            cardDetails.style.display = "none";
        }
    };

    // Виклик функції при завантаженні сторінки
    toggleCardDetails();

    // Відстеження змін у способі оплати
    paymentMethod.addEventListener("change", toggleCardDetails);


    // Приховати підказки, якщо користувач натискає поза списком
    document.addEventListener("click", (event) => {
        if (!citySuggestions.contains(event.target) && event.target !== cityInput) {
            citySuggestions.style.display = "none";
        }
    });

});
