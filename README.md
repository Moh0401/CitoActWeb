# CitoAct - Plateforme de Citoyenneté Active (Web)

CitoAct est une plateforme de citoyenneté active développée avec **Angular** et **Ionic**, permettant aux citoyens de proposer et suivre des actions pour le développement de leur communauté.

## 🚀 Fonctionnalités

- **Authentification** : Connexion et inscription des utilisateurs.
- **Tableau de bord** : Vue d'ensemble des actions en cours et statistiques.
- **Gestion des utilisateurs** : Liste des citoyens avec validation et suppression.
- **Actions en attente** : Modération des propositions citoyennes.
- **Navigation** : Interface fluide avec une barre latérale et Angular Material.

## 🛠 Technologies Utilisées

- **flutter web** (Framework frontend)
- **Firebase** (Authentification et base de données)

## 📦 Installation

1. **Cloner le dépôt**
```bash
git clone https://github.com/ton-utilisateur/citoact-web.git
cd citoact-web
```

2. **Installer les dépendances**
```bash
npm install
```

## 🔐 Configuration Firebase
Avant de lancer le projet, ajoute ton fichier de configuration Firebase dans **src/environments/environment.ts** :

```typescript
export const environment = {
  production: false,
  firebase: {
    apiKey: "TON_API_KEY",
    authDomain: "TON_AUTH_DOMAIN",
    projectId: "TON_PROJECT_ID",
    storageBucket: "TON_STORAGE_BUCKET",
    messagingSenderId: "TON_MESSAGING_SENDER_ID",
    appId: "TON_APP_ID"
  }
};
```

## 📜 License
Ce projet est sous licence MIT.

## 📞 Contact
Si tu as des questions ou des suggestions, n'hésite pas à me contacter ! 🚀

