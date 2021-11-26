I.1 requetage simple

"N'afficher que les 10 premiers produits"

SELECT * 
    FROM Produit
    LIMIT 10;

"Lister les trois produits les plus chers"

SELECT * 
    FROM Produit
    ORDER BY PrixUnit DESC
    LIMIT 3;

I.2 Restriction 

"Lister les clients dont le numéro de fax n'est pas renseigné"
SELECT * 
    FROM Client
    WHERE Fax IS NULL;

 "Lister les clients dont le nom contient restaurant"   
 SELECT * 
    FROM Client
    WHERE Societe LIKE "%restaurant%";

I.3 projection

"Lister uniquement la description des catégories de produits (table Categorie)"
SELECT Description 
    FROM Categorie;

"Lister les différents pays des clients trié par ordre alphabétique du pays et de la ville"

SELECT DISTINCT Pays, Ville
    FROM Client
    ORDER BY 1, 2;

"Lister les différents pays des clients"
    SELECT DISTINCT Pays 
    FROM Client;

    II.calcul arithmetique

    SELECT PrixUnit,
        ROUND(Remise * 100) || "%" as Remise,
        Qte as "Quantité",
        ROUND(PrixUnit * Remise * Qte, 2) as "Montant Remise",
        ROUND(PrixUnit * Qte * (1 - Remise), 2) as "Montant à payer"
    FROM DetailCommande
    WHERE NoCom = 10251;


    II.3 fonction sur chaine de caracteres
SELECT CodeCli, Societe,
        Adresse || ", " || CodePostal || " " || Ville || ", " || Pays as Adresse,
        SUBSTR(CodeCli, LENGTH(CodeCli) - 1, 2) as "Derniers caractères",
        LOWER(Societe) as "Nom",
        REPLACE(Fonction, "marketing", "mercatique") as Fonction,
        CASE
            WHEN INSTR(UPPER(Fonction), "CHEF") > 0 THEN "C'est un chef"
            ELSE ""
        END AS "Chef ?"
    FROM Client;


    III- Agregats

    III.1-Denombrement

    "Calculer le nombre de produits de catégorie 1, des fournisseurs 1 et 18"
    SELECT COUNT(*) 
    FROM Produit
    WHERE CodeCateg = 1
    AND NoFour IN (1, 18);

    "Calculer le nombre de pays différents de livraison"

    SELECT COUNT(DISTINCT PaysLiv) 
    FROM Commande;

    III.2-calcul simple

    "Calculer le coût moyen du port pour les commandes du client QUICK"

    SELECT ROUND(AVG(Port), 2) as PortMoyen
    FROM Commande
    WHERE CodeCli = "QUICK";

    "Pour chaque messager (par leur numéro : 1, 2 et 3), donner le montant total des frais de port leur correspondant"
    SELECT SUM(Port)
    FROM Commande
    WHERE NoMess = 1;

    SELECT SUM(Port)
    FROM Commande
    WHERE NoMess = 2;

    SELECT SUM(Port)
    FROM Commande
    WHERE NoMess = 3;

    III.3"Agrégats selon attribut(s)"


    "Donner le nombre d'employés par fonction"
    SELECT Fonction, COUNT(*) AS NbEmployes
    FROM Employe
    GROUP BY Fonction;

    "Donner le nombre de catégories de produits fournis par chaque fournisseur"
    SELECT NoFour,
        COUNT(*) AS NbProduitsFournis  ,
        COUNT(DISTINCT CodeCateg) AS NbCategories
    FROM Produit
    GROUP BY NoFour;

    "Donner le prix moyen des produits pour chaque fournisseur et chaque catégorie de produits fournis par celui-ci"
    SELECT NoFour, CodeCateg, 
        AVG(PrixUnit) AS PrixMoyen
    FROM Produit
    GROUP By NoFour, CodeCateg;

    IV.1 jointure naturelles

    "Récupérer les informations des fournisseurs pour chaque produit"
    SELECT *
    FROM Produit NATURAL JOIN Fournisseur;

    "Afficher les informations des commandes du client Lazy K Kountry Store"
    SELECT *
    FROM Client NATURAL JOIN Commande
    WHERE Societe = "Lazy K Kountry Store";

    "Afficher le nombre de commande pour chaque messager (en indiquant son nom)"
    SELECT NomMess, COUNT(*) as "Nb Commandes"
    FROM Messager NATURAL JOIN Commande
    GROUP BY NomMess;


    IV.2-Jointures internes

    "Récupérer les informations des fournisseurs pour chaque produit"
    SELECT *
    FROM Produit INNER JOIN Fournisseur
        ON Produit.NoFour = Fournisseur.NoFour;


    "Afficher les informations des commandes du client Lazy K Kountry Store"
      SELECT *
    FROM Commande INNER JOIN Client
        ON Commande.CodeCli = Client.Codecli
    WHERE Societe = "Lazy K Kountry Store";


    "Afficher le nombre de commande pour chaque messager (en indiquant son nom)"
      SELECT NomMess, COUNT(*)
    FROM Commande INNER JOIN Messager
        ON Commande.NoMess = Messager.NoMess
    GROUP BY NomMess;


    IV.3 Jointures externes


    "Compter pour chaque produit, le nombre de commandes où il apparaît, même pour ceux dans aucune commande"
    SELECT NomProd, COUNT(DISTINCT NoCom)
    FROM Produit LEFT OUTER JOIN DetailCommande
        ON Produit.RefProd = DetailCommande.RefProd
    GROUP BY NomProd;


    "Lister les produits n'apparaissant dans aucune commande"
    SELECT NomProd
    FROM Produit LEFT OUTER JOIN DetailCommande
        ON Produit.RefProd = DetailCommande.RefProd
    GROUP BY NomProd
    HAVING COUNT(DISTINCT NoCom) = 0;

    "Existe-t'il un employé n'ayant enregistré aucune commande ?"
    SELECT Nom, Prenom
    FROM Employe LEFT OUTER JOIN Commande
        ON Employe.NoEmp = Commande.NoEmp
    GROUP BY Nom, Prenom
    HAVING COUNT(DISTINCT NoCom) = 0;


    IV.4-Jointures à la main

    "Récupérer les informations des fournisseurs pour chaque produit, avec jointure à la main"
    SELECT *
    FROM Produit, Fournisseur
    WHERE Produit.NoFour = Fournisseur.NoFour;


    "Afficher les informations des commandes du client "Lazy K Kountry Store", avec jointure à la main"
    SELECT *
    FROM Commande, Client
    WHERE Commande.CodeCli = Client.Codecli
    AND Societe = "Lazy K Kountry Store";


    "Afficher le nombre de commande pour chaque messager (en indiquant son nom), avec jointure à la main"
    SELECT NomMess, COUNT(*)
    FROM Commande, Messager
    WHERE Commande.NoMess = Messager.NoMess
    GROUP BY NomMess;

    V-sous-requete

    V.1 sous-requetage
    
    "Lister les employés n'ayant jamais effectué une commande, via une sous-requête"
    SELECT Nom, Prenom
    FROM Employe
    WHERE NoEmp NOT IN (SELECT NoEmp
                            FROM Commande);

     "Nombre de produits proposés par la société fournisseur Mayumi's, via une sous-requête"
     SELECT COUNT(*)
    FROM Produit
    WHERE NoFour = (SELECT NoFour
                        FROM Fournisseur
                        WHERE Societe = "Mayumis");


  "Nombre de commandes passées par des employés sous la responsabilité de Patrick Emery"

    SELECT COUNT(*)
    FROM Commande
    WHERE NoEmp IN (SELECT NoEmp
                        FROM Employe
                        WHERE RendCompteA = (SELECT NoEmp
                                                FROM Employe
                                                WHERE Nom = "Emery"
                                                AND Prenom = "Patrick"));                                           







