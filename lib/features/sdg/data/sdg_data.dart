import 'package:flutter/material.dart';

/// UN Sustainable Development Goal data
class SdgGoal {
  const SdgGoal({
    required this.number,
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.color,
    required this.iconUrl,
  });

  final int number;
  final String title;
  final String shortTitle;
  final String description;
  final Color color;
  final String iconUrl;
}

/// All 17 UN Sustainable Development Goals
/// Colors from official UN SDG Guidelines
/// https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/01/SDG_Guidelines_AUG_2019_Final.pdf
const sdgGoals = <SdgGoal>[
  SdgGoal(
    number: 1,
    title: 'No Poverty',
    shortTitle: 'No Poverty',
    description:
        'End poverty in all its forms everywhere. More than 700 million '
        'people still live in extreme poverty and are struggling to fulfil '
        'the most basic needs like health, education, and access to water '
        'and sanitation. The overwhelming majority of people living on less '
        r'than $1.90 a day live in Southern Asia and sub-Saharan Africa. '
        'The goal calls for social protection systems, equal rights to '
        'economic resources, and support for those affected by climate-related '
        'disasters and other shocks.',
    color: Color(0xFFE5233D),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-01.jpg',
  ),
  SdgGoal(
    number: 2,
    title: 'Zero Hunger',
    shortTitle: 'Zero Hunger',
    description:
        'End hunger, achieve food security and improved nutrition and promote '
        'sustainable agriculture. After decades of steady decline, the number '
        'of people who suffer from hunger has slowly increased since 2015. '
        'An estimated 690 million people are hungry. The food and agriculture '
        'sector offers key solutions for development. Agriculture is the single '
        'largest employer in the world, providing livelihoods for 40% of the '
        'global population. It is the largest source of income for poor rural '
        'households.',
    color: Color(0xFFDDA73A),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-02.jpg',
  ),
  SdgGoal(
    number: 3,
    title: 'Good Health and Well-Being',
    shortTitle: 'Good Health',
    description:
        'Ensure healthy lives and promote well-being for all at all ages. '
        'We have made great progress against several leading causes of death '
        'and disease. Life expectancy has increased dramatically; infant and '
        'maternal mortality rates have declined. We have turned the tide on '
        'HIV and malaria deaths. However, more efforts are needed to fully '
        'eradicate diseases and address persistent and emerging health issues.',
    color: Color(0xFF4CA146),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-03.jpg',
  ),
  SdgGoal(
    number: 4,
    title: 'Quality Education',
    shortTitle: 'Education',
    description:
        'Ensure inclusive and equitable quality education and promote lifelong '
        'learning opportunities for all. Education enables upward socioeconomic '
        'mobility and is a key to escaping poverty. Over the past decade, major '
        'progress was made towards increasing access to education and school '
        'enrollment rates at all levels. Nevertheless, about 260 million '
        'children were still out of school in 2018.',
    color: Color(0xFFC5192D),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-04.jpg',
  ),
  SdgGoal(
    number: 5,
    title: 'Gender Equality',
    shortTitle: 'Gender Equality',
    description:
        'Achieve gender equality and empower all women and girls. Gender '
        'equality is not only a fundamental human right, but a necessary '
        'foundation for a peaceful, prosperous and sustainable world. '
        'Providing women and girls with equal access to education, health '
        'care, decent work, and representation in political and economic '
        'decision-making processes will fuel sustainable economies and '
        'benefit societies and humanity at large.',
    color: Color(0xFFEF402C),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-05.jpg',
  ),
  SdgGoal(
    number: 6,
    title: 'Clean Water and Sanitation',
    shortTitle: 'Clean Water',
    description:
        'Ensure availability and sustainable management of water and sanitation '
        'for all. Water scarcity affects more than 40% of people around the '
        'world. This is projected to increase with the rise of global '
        'temperatures. Since 1990, 2.1 billion people have gained access to '
        'improved water sanitation, but dwindling supplies of safe drinking '
        'water is a major problem impacting every continent.',
    color: Color(0xFF27BFE6),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-06.jpg',
  ),
  SdgGoal(
    number: 7,
    title: 'Affordable and Clean Energy',
    shortTitle: 'Clean Energy',
    description:
        'Ensure access to affordable, reliable, sustainable and modern energy '
        'for all. Energy is central to nearly every major challenge and '
        'opportunity the world faces today. Be it for jobs, security, climate '
        'change, food production or increasing incomes, access to energy for '
        'all is essential. The world is making good progress: energy access in '
        'poorer countries has begun to accelerate, and energy efficiency '
        'continues to improve.',
    color: Color(0xFFFBC412),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-07.jpg',
  ),
  SdgGoal(
    number: 8,
    title: 'Decent Work and Economic Growth',
    shortTitle: 'Decent Work',
    description:
        'Promote sustained, inclusive and sustainable economic growth, full '
        'and productive employment and decent work for all. Roughly half the '
        r"world's population still lives on the equivalent of about US$2 a day. "
        'In many places, having a job does not guarantee the ability to escape '
        'from poverty. This slow and uneven progress requires us to rethink and '
        'retool our economic and social policies aimed at eradicating poverty.',
    color: Color(0xFFA31C44),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-08.jpg',
  ),
  SdgGoal(
    number: 9,
    title: 'Industry, Innovation and Infrastructure',
    shortTitle: 'Innovation',
    description:
        'Build resilient infrastructure, promote inclusive and sustainable '
        'industrialization and foster innovation. Investment in infrastructure '
        'and innovation are crucial drivers of economic growth and development. '
        'With over half the world population now living in cities, mass '
        'transport and renewable energy are becoming ever more important, as '
        'are the growth of new industries and information and communication '
        'technologies.',
    color: Color(0xFFF26A2D),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-09.jpg',
  ),
  SdgGoal(
    number: 10,
    title: 'Reduced Inequalities',
    shortTitle: 'Equality',
    description:
        'Reduce inequality within and among countries. Income inequality is on '
        'the rise, with the richest 10% earning up to 40% of total global '
        'income. The poorest 10% earn only 2-7% of total global income. In '
        'developing countries, inequality has increased by 11% if we take into '
        'account population growth. These widening disparities require sound '
        'policies to empower lower income earners.',
    color: Color(0xFFE01483),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-10.jpg',
  ),
  SdgGoal(
    number: 11,
    title: 'Sustainable Cities and Communities',
    shortTitle: 'Sustainable Cities',
    description:
        'Make cities and human settlements inclusive, safe, resilient and '
        'sustainable. Cities are hubs for ideas, commerce, culture, science, '
        'productivity, social development and much more. At their best, cities '
        'have enabled people to advance socially and economically. However, '
        'many challenges exist to maintaining cities in a way that continues '
        'to create jobs and prosperity without straining land and resources.',
    color: Color(0xFFF89D2A),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-11.jpg',
  ),
  SdgGoal(
    number: 12,
    title: 'Responsible Consumption and Production',
    shortTitle: 'Responsible Consumption',
    description:
        'Ensure sustainable consumption and production patterns. Achieving '
        'economic growth and sustainable development requires that we urgently '
        'reduce our ecological footprint by changing the way we produce and '
        'consume goods and resources. Agriculture is the biggest user of water '
        'worldwide, and irrigation now claims close to 70% of all freshwater '
        'for human use.',
    color: Color(0xFFBF8D2C),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-12.jpg',
  ),
  SdgGoal(
    number: 13,
    title: 'Climate Action',
    shortTitle: 'Climate Action',
    description:
        'Take urgent action to combat climate change and its impacts. Climate '
        'change affects every country on every continent. It is disrupting '
        'national economies and affecting lives and livelihoods. Weather '
        'patterns are changing, sea levels are rising, and weather events are '
        'becoming more extreme. Greenhouse gas emissions are now at their '
        'highest levels in history.',
    color: Color(0xFF407F46),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-13.jpg',
  ),
  SdgGoal(
    number: 14,
    title: 'Life Below Water',
    shortTitle: 'Life Below Water',
    description:
        'Conserve and sustainably use the oceans, seas and marine resources '
        'for sustainable development. The oceans drive global systems that '
        'make the Earth habitable for humankind. Our rainwater, drinking water, '
        'weather, climate, coastlines, much of our food, and even the oxygen '
        'in the air we breathe, are all ultimately provided and regulated by '
        'the sea. Careful management of this essential global resource is a '
        'key feature of a sustainable future.',
    color: Color(0xFF1F97D4),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-14.jpg',
  ),
  SdgGoal(
    number: 15,
    title: 'Life on Land',
    shortTitle: 'Life on Land',
    description:
        'Protect, restore and promote sustainable use of terrestrial '
        'ecosystems, sustainably manage forests, combat desertification, '
        'and halt and reverse land degradation and halt biodiversity loss. '
        'Human life depends on the earth as much as the ocean for sustenance '
        'and livelihoods. Forests cover 30% of the Earth and provide vital '
        'habitats for millions of species and important sources for clean air '
        'and water.',
    color: Color(0xFF59BA48),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-15.jpg',
  ),
  SdgGoal(
    number: 16,
    title: 'Peace, Justice and Strong Institutions',
    shortTitle: 'Peace & Justice',
    description:
        'Promote peaceful and inclusive societies for sustainable development, '
        'provide access to justice for all and build effective, accountable '
        'and inclusive institutions at all levels. Conflict, insecurity, weak '
        'institutions and limited access to justice remain a great threat to '
        'sustainable development. Armed violence and insecurity have a '
        'destructive impact on development, affecting economic growth and '
        'often resulting in long-standing grievances.',
    color: Color(0xFF126A9F),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-16.jpg',
  ),
  SdgGoal(
    number: 17,
    title: 'Partnerships for the Goals',
    shortTitle: 'Partnerships',
    description:
        'Strengthen the means of implementation and revitalize the Global '
        'Partnership for Sustainable Development. The SDGs can only be '
        'realized with strong global partnerships and cooperation. A '
        'successful development agenda requires inclusive partnerships '
        'between governments, the private sector and civil society. These '
        'partnerships built upon principles and values, a shared vision, and '
        'shared goals that place people and the planet at the centre.',
    color: Color(0xFF13496B),
    iconUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-17.jpg',
  ),
];
