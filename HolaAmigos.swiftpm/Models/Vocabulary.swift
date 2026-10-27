import Foundation

/// One vocabulary item. Nouns include their article ("el perro") so kids
/// learn the gender along with the word.
struct Word: Identifiable, Hashable {
    let spanish: String
    let english: String
    let emoji: String

    var id: String { spanish }
}

struct Topic: Identifiable, Hashable {
    let id: String
    let title: String       // Spanish
    let subtitle: String    // English
    let emoji: String
    let hue: Double         // 0...1, used for the topic's color
    let words: [Word]
}

/// All learning content. Add a topic by appending to `topics`; every topic
/// needs at least 3 words for the quiz.
enum Vocabulary {
    static let topics: [Topic] = [
        Topic(id: "colors", title: "Colores", subtitle: "Colors", emoji: "🎨", hue: 0.0, words: [
            Word(spanish: "rojo", english: "red", emoji: "🔴"),
            Word(spanish: "azul", english: "blue", emoji: "🔵"),
            Word(spanish: "verde", english: "green", emoji: "🟢"),
            Word(spanish: "amarillo", english: "yellow", emoji: "🟡"),
            Word(spanish: "naranja", english: "orange", emoji: "🟠"),
            Word(spanish: "morado", english: "purple", emoji: "🟣"),
            Word(spanish: "marrón", english: "brown", emoji: "🟤"),
            Word(spanish: "negro", english: "black", emoji: "⚫️"),
            Word(spanish: "blanco", english: "white", emoji: "⚪️"),
            Word(spanish: "rosa", english: "pink", emoji: "🩷")
        ]),
        Topic(id: "animals", title: "Animales", subtitle: "Animals", emoji: "🐶", hue: 0.08, words: [
            Word(spanish: "el perro", english: "dog", emoji: "🐶"),
            Word(spanish: "el gato", english: "cat", emoji: "🐱"),
            Word(spanish: "el pájaro", english: "bird", emoji: "🐦"),
            Word(spanish: "el pez", english: "fish", emoji: "🐟"),
            Word(spanish: "el caballo", english: "horse", emoji: "🐴"),
            Word(spanish: "la vaca", english: "cow", emoji: "🐮"),
            Word(spanish: "el cerdo", english: "pig", emoji: "🐷"),
            Word(spanish: "la rana", english: "frog", emoji: "🐸"),
            Word(spanish: "el oso", english: "bear", emoji: "🐻"),
            Word(spanish: "el mono", english: "monkey", emoji: "🐵")
        ]),
        Topic(id: "numbers", title: "Números", subtitle: "Numbers", emoji: "🔢", hue: 0.58, words: [
            Word(spanish: "uno", english: "one", emoji: "1️⃣"),
            Word(spanish: "dos", english: "two", emoji: "2️⃣"),
            Word(spanish: "tres", english: "three", emoji: "3️⃣"),
            Word(spanish: "cuatro", english: "four", emoji: "4️⃣"),
            Word(spanish: "cinco", english: "five", emoji: "5️⃣"),
            Word(spanish: "seis", english: "six", emoji: "6️⃣"),
            Word(spanish: "siete", english: "seven", emoji: "7️⃣"),
            Word(spanish: "ocho", english: "eight", emoji: "8️⃣"),
            Word(spanish: "nueve", english: "nine", emoji: "9️⃣"),
            Word(spanish: "diez", english: "ten", emoji: "🔟")
        ]),
        Topic(id: "food", title: "Comida", subtitle: "Food", emoji: "🍎", hue: 0.3, words: [
            Word(spanish: "la manzana", english: "apple", emoji: "🍎"),
            Word(spanish: "el plátano", english: "banana", emoji: "🍌"),
            Word(spanish: "el pan", english: "bread", emoji: "🍞"),
            Word(spanish: "la leche", english: "milk", emoji: "🥛"),
            Word(spanish: "el queso", english: "cheese", emoji: "🧀"),
            Word(spanish: "el huevo", english: "egg", emoji: "🥚"),
            Word(spanish: "la fresa", english: "strawberry", emoji: "🍓"),
            Word(spanish: "el agua", english: "water", emoji: "💧"),
            Word(spanish: "la galleta", english: "cookie", emoji: "🍪"),
            Word(spanish: "la zanahoria", english: "carrot", emoji: "🥕")
        ]),
        Topic(id: "family", title: "Familia", subtitle: "Family", emoji: "👨‍👩‍👧", hue: 0.78, words: [
            Word(spanish: "la mamá", english: "mom", emoji: "👩"),
            Word(spanish: "el papá", english: "dad", emoji: "👨"),
            Word(spanish: "la hermana", english: "sister", emoji: "👧"),
            Word(spanish: "el hermano", english: "brother", emoji: "👦"),
            Word(spanish: "la abuela", english: "grandma", emoji: "👵"),
            Word(spanish: "el abuelo", english: "grandpa", emoji: "👴"),
            Word(spanish: "el bebé", english: "baby", emoji: "👶")
        ]),
        Topic(id: "body", title: "El cuerpo", subtitle: "My body", emoji: "🙋", hue: 0.9, words: [
            Word(spanish: "el ojo", english: "eye", emoji: "👁️"),
            Word(spanish: "la nariz", english: "nose", emoji: "👃"),
            Word(spanish: "la boca", english: "mouth", emoji: "👄"),
            Word(spanish: "la oreja", english: "ear", emoji: "👂"),
            Word(spanish: "la mano", english: "hand", emoji: "✋"),
            Word(spanish: "el pie", english: "foot", emoji: "🦶"),
            Word(spanish: "el diente", english: "tooth", emoji: "🦷"),
            Word(spanish: "la pierna", english: "leg", emoji: "🦵")
        ])
    ]

    static let praise = ["¡Muy bien!", "¡Excelente!", "¡Fantástico!", "¡Bravo!", "¡Genial!", "¡Sí, señor!"]
}
