-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : ven. 14 mars 2025 à 01:59
-- Version du serveur :  10.4.14-MariaDB
-- Version de PHP : 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `e_wallet`
--

-- --------------------------------------------------------

--
-- Structure de la table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) DEFAULT NULL,
  `receiver_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `transaction_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_read` tinyint(1) DEFAULT 0,
  `seen_by_admin` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `transactions`
--

INSERT INTO `transactions` (`id`, `sender_id`, `receiver_id`, `amount`, `transaction_date`, `is_read`, `seen_by_admin`) VALUES
(3, 1, 2, '124.00', '2025-02-15 04:20:29', 1, 1),
(5, 2, 2, '300.00', '2025-02-16 01:15:45', 1, 1),
(6, 2, 2, '300.00', '2025-02-16 01:16:31', 1, 1),
(7, 2, 2, '45.00', '2025-02-16 01:18:24', 1, 1),
(10, 2, 2, '10.00', '2025-02-16 01:26:28', 1, 1),
(60, 3, 2, '100.00', '2025-03-10 02:47:28', 1, 1),
(61, 3, 2, '50.00', '2025-03-10 02:48:06', 1, 1),
(62, 2, 3, '5.00', '2025-03-10 02:48:28', 1, 1),
(63, 2, 3, '30.00', '2025-03-10 02:49:20', 1, 1),
(64, 3, 2, '500.00', '2025-03-10 02:50:14', 1, 1),
(65, 3, 2, '50.00', '2025-03-10 02:50:32', 1, 1),
(67, 3, 2, '50.00', '2025-03-10 02:58:17', 1, 1),
(71, 3, 2, '50.00', '2025-03-10 04:06:56', 1, 1),
(72, 3, 2, '4.00', '2025-03-10 04:09:19', 1, 1),
(73, 2, 3, '3.00', '2025-03-10 04:10:58', 1, 1),
(75, 3, 2, '50.00', '2025-03-10 05:04:42', 1, 1),
(80, 2, 3, '1.00', '2025-03-10 15:48:36', 1, 1),
(81, 3, 2, '4000.00', '2025-03-10 15:49:38', 1, 1),
(82, 3, 1, '-5.10', '2025-03-10 15:53:50', 1, 1),
(83, 2, 1, '-5.10', '2025-03-10 16:46:06', 1, 1),
(84, 2, 3, '500.00', '2025-03-10 16:56:23', 1, 1),
(85, 2, 1, '-10.20', '2025-03-10 16:57:33', 1, 1),
(91, 1, 2, '1.00', '2025-03-10 18:51:05', 1, 1),
(92, 2, 1, '-1020.00', '2025-03-10 19:00:58', 1, 1),
(93, 1, 2, '1.00', '2025-03-10 19:35:34', 1, 1),
(94, 2, 1, '-51.00', '2025-03-10 19:42:15', 1, 1),
(95, 1, 2, '50.00', '2025-03-10 19:45:10', 1, 1),
(96, 2, 3, '500.00', '2025-03-10 19:45:52', 1, 1),
(97, 1, 2, '1.00', '2025-03-10 20:44:47', 1, 1),
(99, 2, 1, '-51.00', '2025-03-10 21:08:31', 1, 1),
(100, 2, 1, '-339.66', '2025-03-10 21:15:52', 1, 1),
(101, 1, 2, '500.00', '2025-03-10 21:29:57', 1, 1),
(102, 1, 2, '1.00', '2025-03-10 21:30:31', 1, 1),
(103, 1, 2, '2.00', '2025-03-10 21:30:46', 1, 1),
(104, 1, 2, '1.00', '2025-03-10 21:31:49', 1, 1),
(105, 2, 1, '-5.10', '2025-03-10 21:58:00', 1, 1),
(106, 2, 1, '-5.10', '2025-03-10 21:58:57', 1, 1),
(107, 1, 2, '5.00', '2025-03-11 00:48:05', 1, 1),
(109, 1, 2, '1.00', '2025-03-13 02:23:51', 1, 1),
(110, 1, 2, '1.00', '2025-03-13 02:23:52', 1, 1),
(111, 1, 2, '1.00', '2025-03-13 02:23:53', 1, 1),
(112, 1, 2, '1.00', '2025-03-13 02:23:53', 1, 1),
(113, 1, 2, '1.00', '2025-03-13 02:23:54', 1, 1),
(114, 1, 2, '1.00', '2025-03-13 02:23:54', 1, 1),
(115, 1, 2, '1.00', '2025-03-13 02:23:54', 1, 1),
(116, 1, 2, '1.00', '2025-03-13 02:23:55', 1, 1),
(117, 1, 2, '1.00', '2025-03-13 02:23:55', 1, 1),
(118, 1, 2, '1.00', '2025-03-13 02:23:55', 1, 1),
(119, 1, 2, '1.00', '2025-03-13 02:23:55', 1, 1),
(120, 1, 2, '1.00', '2025-03-13 02:23:55', 1, 1),
(121, 1, 2, '1.00', '2025-03-13 02:23:55', 1, 1),
(122, 1, 10, '11.00', '2025-03-13 02:32:30', 0, 1),
(123, 1, 2, '4.00', '2025-03-13 02:33:17', 1, 1),
(124, 2, 1, '-510.00', '2025-03-13 02:37:26', 0, 1),
(125, 2, 3, '50.00', '2025-03-13 02:39:06', 1, 1),
(126, 2, 3, '1000.00', '2025-03-13 02:39:34', 1, 1),
(127, 3, 2, '1000.00', '2025-03-13 02:40:14', 1, 1),
(128, 2, 3, '500.00', '2025-03-13 06:17:12', 1, 1),
(129, 2, 1, '-510.00', '2025-03-13 06:20:03', 0, 1),
(130, 2, 3, '500.00', '2025-03-14 00:14:22', 1, 1),
(131, 2, 1, '-4080.00', '2025-03-14 00:16:15', 0, 1),
(132, 1, 2, '5000.00', '2025-03-14 00:17:19', 1, 1),
(133, 1, 14, '5000.00', '2025-03-14 00:19:34', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `balance` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `balance`) VALUES
(1, 'admin', 'fjkdsl', 'ad@gmail.com', '5006463.00'),
(2, 'user1', 'fjkdsl', 'us1@gmail.com', '37610.84'),
(3, 'user2', 'fjkdsl', 'us2@gmail.com', '46083.00'),
(10, 'user4', 'fjkdsl', 'us4@gmail.com', '11.00'),
(11, 'user5', 'fjkdsl', 'us5@gmail.com', '0.00'),
(14, 'user7', '12345', 'us7@gmail.com', '5000.00');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=134;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
