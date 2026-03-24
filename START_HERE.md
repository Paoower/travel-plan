# 🚀 DÉMARRER ICI - PHASE 2
**Bienvenue!** Si vous venez juste de cloner ce projet, commencez par ceci.
---
## ⚡ EN 5 MINUTES
```bash
# 1. Aller au répertoire du projet
cd /home/romain/Z01/projets/travel-plan
# 2. Vérifier que tout fonctionne
bash test-phase2.sh
# 3. Démarrer la base de données
docker-compose up -d postgres neo4j
# 4. Lire le guide rapide
cat QUICKSTART.md
```
---
## 👥 CHOISISSEZ VOTRE RÔLE
### 👨‍💻 Je suis PERSONNE 2 (Backend)
→ Aller à: `PHASE2_DASHBOARD.md` (section Auth Service)  
→ Commandes: `grep "Personne 2" QUICKSTART.md`  
→ TODO: Implémenter Auth Service  
### 🔧 Je suis PERSONNE 1 (DevOps)
→ Aller à: `PHASE2_DASHBOARD.md` (section Ansible)  
→ Commandes: `grep "Ansible" QUICKSTART.md`  
→ TODO: Créer playbooks Ansible  
### 🎨 Je suis PERSONNE 3 (Frontend/QA)
→ Aller à: `PHASE2_DASHBOARD.md` (section Dashboard)  
→ Commandes: `grep "React\|Dashboard" QUICKSTART.md`  
→ TODO: Créer Admin Dashboard  
### 📊 Je suis Manager/Lead
→ Aller à: `README_PHASE2.md`  
→ Voir: Tous les documents créés  
→ Priorité: Phase 2 Status & Timeline  
---
## 📚 QUEL DOCUMENT LIRE?
| Besoin | Fichier | Temps |
|--------|---------|-------|
| Commandes rapides | QUICKSTART.md | 5 min |
| Plan complet | PHASE2_DASHBOARD.md | 20 min |
| Vue d'ensemble | README_PHASE2.md | 5 min |
| État du projet | PHASE2_STATUS.md | 10 min |
| Test l'infra | test-phase2.sh | 2 min |
---
## ✅ CHECKLIST PREMIÈRE HEURE
- [ ] Lancer `bash test-phase2.sh`
- [ ] Lancer `docker-compose up -d postgres neo4j`
- [ ] Lire `QUICKSTART.md`
- [ ] Lire `PHASE2_DASHBOARD.md` (votre section)
- [ ] Créer les répertoires de base
---
## 🔍 LIENS RAPIDES
```bash
# Structure du projet
ls -la docs/
ls -la services/
# Vérifier l'infrastructure
docker-compose ps
docker-compose logs postgres
# Compiler le code
mvn clean package -DskipTests
# Lancer les tests
bash test-phase2.sh
```
---
## 📍 DOCUMENTS ESSENTIELS (À LIRE)
1. **QUICKSTART.md** ← Commandes essentielles
2. **PHASE2_DASHBOARD.md** ← Plan détaillé
3. **PHASE2_STATUS.md** ← Timeline & dépendances
4. **README_PHASE2.md** ← Vue d'ensemble
---
**Status**: ✅ Prêt pour Phase 2  
**Date**: 24 Mars 2026  
**Prochaine étape**: Lire QUICKSTART.md  
