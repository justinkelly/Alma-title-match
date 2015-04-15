--
-- Database: `library`
--

-- --------------------------------------------------------

--
-- Table structure for table `overlap_electronic`
--

CREATE TABLE IF NOT EXISTS `overlap_electronic` (
  `id` int(10) NOT NULL,
  `alma_id` bigint(20) DEFAULT NULL,
  `isbn` bigint(20) DEFAULT NULL,
  `title` text,
  `alt_title` text,
  `type` varchar(255) NOT NULL DEFAULT 'electronic'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `overlap_overlap`
--

CREATE TABLE IF NOT EXISTS `overlap_overlap` (
  `alma_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `overlap_physical`
--

CREATE TABLE IF NOT EXISTS `overlap_physical` (
  `id` int(10) NOT NULL,
  `alma_id` bigint(20) DEFAULT NULL,
  `isbn` bigint(20) DEFAULT NULL,
  `title` text,
  `alt_title` text,
  `type` varchar(255) NOT NULL DEFAULT 'physical'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `overlap_electronic`
--
ALTER TABLE `overlap_electronic`
  ADD PRIMARY KEY (`id`),
  ADD KEY `electronic_alma_id` (`alma_id`),
  ADD KEY `electronic_isbn` (`isbn`);

--
-- Indexes for table `overlap_overlap`
--
ALTER TABLE `overlap_overlap`
  ADD KEY `alma_id_index` (`alma_id`);

--
-- Indexes for table `overlap_physical`
--
ALTER TABLE `overlap_physical`
  ADD PRIMARY KEY (`id`),
  ADD KEY `physical_alma_id` (`alma_id`),
  ADD KEY `physical_isbn` (`isbn`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `overlap_electronic`
--
ALTER TABLE `overlap_electronic`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `overlap_physical`
--
ALTER TABLE `overlap_physical`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;
