-- Keep a log of any SQL queries you execute as you solve the mystery.
-- Começamos verificando o relatório da cena do crime para o dia e local corretos.
-- O roubo ocorreu em 28 de julho de 2023, na "Humphrey Street".
SELECT description
FROM crime_scene_reports
WHERE year = 2023 AND month = 7 AND day = 28 AND street = 'Humphrey Street';

-- O resultado menciona: "Roubo do pato CS50 ocorreu às 10h15. [...] Entrevistas com três testemunhas
-- presentes no momento do roubo. Todas as três testemunhas mencionam a 'padaria' (bakery) em suas transcrições."
-- Precisamos ler essas entrevistas.

-- Etapa 2: Verificar as transcrições das entrevistas que mencionam a "padaria".
SELECT name, transcript
FROM interviews
WHERE year = 2023 AND month = 7 AND day = 28 AND transcript LIKE '%bakery%';

-- Os resultados nos dão três pistas cruciais:
-- 1. (Ruth) O ladrão saiu do estacionamento da padaria em um carro, algum tempo depois das 10h15,
--    dentro de 10 minutos (ou seja, entre 10h15 e 10h25).
-- 2. (Eugene) O ladrão foi visto sacando dinheiro em um caixa eletrônico na "Leggett Street"
--    mais cedo naquela manhã.
-- 3. (Raymond) O ladrão ligou para alguém por menos de um minuto. Eles planejavam pegar
--    o "voo mais cedo" para fora de Fiftyville no dia seguinte (29 de julho). O ladrão comprou a passagem.

-- Vamos investigar cada pista.

-- Pista 1: Registros de segurança da padaria (entre 10h15 e 10h25).
-- Isso nos dará uma lista de placas de carros suspeitos.
SELECT license_plate
FROM bakery_security_logs
WHERE year = 2023 AND month = 7 AND day = 28 AND hour = 10 AND minute BETWEEN 15 AND 25 AND activity = 'exit';

-- Pista 2: Transações no caixa eletrônico (ATM) na "Leggett Street" naquela manhã.
-- Isso nos dará uma lista de números de conta suspeitos.
SELECT account_number
FROM atm_transactions
WHERE year = 2023 AND month = 7 AND day = 28 AND atm_location = 'Leggett Street' AND transaction_type = 'withdraw';

-- Pista 3 (Parte A): Registros telefônicos.
-- Queremos os números dos "chamadores" (caller) que fizeram uma ligação de menos de 60 segundos em 28/07/2023.
SELECT caller
FROM phone_calls
WHERE year = 2023 AND month = 7 AND day = 28 AND duration < 60;

-- Pista 3 (Parte B): O voo mais cedo de amanhã (29/07/2023).
-- Primeiro, encontramos o aeroporto de Fiftyville.
SELECT id FROM airports WHERE city = 'Fiftyville';
-- (Resultado: O ID do aeroporto de Fiftyville é 8)

-- Agora, encontramos o voo mais cedo (menor hora, menor minuto) saindo do aeroporto 8 no dia 29.
SELECT id, destination_airport_id
FROM flights
WHERE year = 2023 AND month = 7 AND day = 29 AND origin_airport_id = 8
ORDER BY hour ASC, minute ASC
LIMIT 1;
-- (Resultado: O voo ID é 36. O ID do aeroporto de destino é 4)

-- Agora, descobrimos para QUAL CIDADE o ladrão escapou (aeroporto ID 4).
SELECT city
FROM airports
WHERE id = 4;
-- (Resultado: New York City. Esta é a cidade de fuga!)

-- Também precisamos da lista de passageiros (números de passaporte) naquele voo (ID 36).
SELECT passport_number
FROM passengers
WHERE flight_id = 36;


-- Etapa 3: Cruzar todas as listas para encontrar o ladrão.
-- Estamos procurando uma única pessoa que apareça em todas as listas de suspeitos:
-- 1. Estava no estacionamento da padaria (bakery_security_logs)
-- 2. Sacou dinheiro (atm_transactions)
-- 3. Fez uma ligação curta (phone_calls)
-- 4. Estava no voo mais cedo (passengers)
-- Usaremos uma consulta grande para cruzar os IDs ('people.id' e 'people.name') com todas as listas.

SELECT people.name
FROM people
JOIN bakery_security_logs ON people.license_plate = bakery_security_logs.license_plate
JOIN bank_accounts ON people.id = bank_accounts.person_id
JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
JOIN phone_calls ON people.phone_number = phone_calls.caller
JOIN passengers ON people.passport_number = passengers.passport_number
WHERE
    -- Condições da Pista 1 (Padaria)
    bakery_security_logs.year = 2023 AND bakery_security_logs.month = 7 AND bakery_security_logs.day = 28
    AND bakery_security_logs.hour = 10 AND bakery_security_logs.minute BETWEEN 15 AND 25 AND bakery_security_logs.activity = 'exit'

    -- Condições da Pista 2 (ATM)
    AND atm_transactions.year = 2023 AND atm_transactions.month = 7 AND atm_transactions.day = 28
    AND atm_transactions.atm_location = 'Leggett Street' AND atm_transactions.transaction_type = 'withdraw'

    -- Condições da Pista 3 (Ligação)
    AND phone_calls.year = 2023 AND phone_calls.month = 7 AND phone_calls.day = 28 AND phone_calls.duration < 60

    -- Condições da Pista 4 (Voo)
    AND passengers.flight_id = 36;

-- (Resultado: A consulta retorna um único nome: Bruce. Encontramos o ladrão!)


-- Etapa 4: Encontrar o Cúmplice.
-- O cúmplice foi a pessoa para quem Bruce ligou (o "receptor" da ligação).
-- Primeiro, pegamos o número de telefone de Bruce.
SELECT phone_number FROM people WHERE name = 'Bruce';
-- (Resultado: (367) 555-5533)

-- Agora, encontramos quem recebeu a ligação curta de Bruce (367-555-5533).
SELECT receiver
FROM phone_calls
WHERE year = 2023 AND month = 7 AND day = 28 AND duration < 60 AND caller = '(367) 555-5533';
-- (Resultado: (375) 555-8161)

-- Finalmente, encontramos o nome associado a esse número de telefone.
SELECT name
FROM people
WHERE phone_number = '(375) 555-8161';

-- (Resultado: Robin. Este é o cúmplice!)

-- Mistério resolvido.
