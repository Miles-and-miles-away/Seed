# Action Library Research Strategy

**Version:** 1.0
**Created:** January 2026
**Status:** Planning

---

## Overview

This document outlines the methodology for researching and expanding the Seed action library from 29 to ~100 actions, ensuring all 17 UN SDGs are covered with accurate CO₂ impact data.

---

## Research Goals

1. **Expand to ~100 actions** covering all 17 UN SDGs
2. **Ensure data accuracy** with verifiable CO₂ impact sources
3. **Maintain consistency** in point values and impact calculations
4. **Support localization** with EN/ES/JA descriptions
5. **Document sources** for transparency and future updates

---

## Primary Data Sources

### Tier 1: Official/Academic Sources (Highest Priority)

| Source | URL | Coverage | Notes |
|--------|-----|----------|-------|
| **UK DEFRA** | [gov.uk/defra](https://www.gov.uk/government/collections/government-conversion-factors-for-company-reporting) | Comprehensive emission factors | Excel downloads, updated annually |
| **EPA (US)** | [epa.gov/ghgemissions](https://www.epa.gov/ghgemissions) | US-specific factors | Various reports and calculators |
| **IPCC** | [ipcc.ch](https://www.ipcc.ch/) | Global standards | Academic, foundational data |
| **Our World in Data** | [ourworldindata.org](https://ourworldindata.org/co2-emissions) | Aggregated, accessible | CC BY license, good for cross-reference |
| **Carbon Trust** | [carbontrust.com](https://www.carbontrust.com/) | Business-focused | UK-based, reliable methodology |

### Tier 2: Calculators & Tools (Cross-Reference)

| Source | URL | Best For |
|--------|-----|----------|
| **CoolClimate Calculator** | [coolclimate.berkeley.edu](https://coolclimate.berkeley.edu/calculator) | Household actions |
| **Carbon Footprint Ltd** | [carbonfootprint.com](https://www.carbonfootprint.com/calculator.aspx) | General calculations |
| **Terrapass** | [terrapass.com](https://www.terrapass.com/carbon-footprint-calculator) | Travel emissions |
| **Resurgence Carbon Calculator** | [resurgence.org](https://www.resurgence.org/resources/carbon-calculator.html) | Lifestyle actions |

### Tier 3: Research Papers & Reports

| Source | Type | Access |
|--------|------|--------|
| **Google Scholar** | Academic papers | Free search |
| **ResearchGate** | Research network | Some free access |
| **UN Environment** | Official reports | Free |
| **Nature Climate Change** | Journal | Subscription/library |

### Tier 4: Secondary Sources (Verify with Tier 1-2)

| Source | URL | Notes |
|--------|-----|-------|
| **Sustainability blogs** | Various | Cross-reference required |
| **News articles** | Various | Often cite primary sources |
| **Infographics** | Various | Trace back to original data |

---

## Research Methodology

### Step 1: Identify Actions per SDG

For each SDG:
1. Review UN SDG targets and indicators
2. Identify individual actions that contribute
3. Categorize as "Direct" or "Indirect/Learn Only"
4. Prioritize high-impact, everyday actions

### Step 2: Research CO₂ Impact

For each action:
1. Search Tier 1 sources first
2. Cross-reference with Tier 2 calculators
3. Document calculation methodology
4. Note any assumptions (e.g., "average US car")

### Step 3: Validate Data

- Compare across 2-3 sources minimum
- Note discrepancies and choose conservative estimate
- Document confidence level (High/Medium/Low)

### Step 4: Calculate Points

Use the established point-to-CO₂ ratio:

| CO₂ Impact | Points | Examples |
|------------|--------|----------|
| 1-100g | 1-5 | Reusable bag, recycling can |
| 100-500g | 5-20 | Short bike ride, composting |
| 500-2000g | 20-50 | Meatless meal, longer bike commute |
| 2000-10000g | 50-200 | Train instead of car trip |
| 10000g+ | 200-500 | Major transport substitutions |

**Formula:** `points = log10(co2Grams) * 15` (approximate, adjusted for user psychology)

### Step 5: Document Everything

For each action, record:
- Action name (EN/ES/JA)
- CO₂ impact (grams)
- Points value
- Primary source
- Secondary source (if available)
- Calculation notes
- Confidence level
- Related SDGs

---

## SDG Research Templates

### Template: Direct Action

```markdown
## Action: [Action Name]

**Category:** [recycling/transport/food/energy/consumption/water/community/advocacy]
**Related SDGs:** [list of SDG numbers]

### CO₂ Impact
- **Value:** XXX grams CO₂e
- **Calculation:** [explain how derived]
- **Primary Source:** [URL]
- **Secondary Source:** [URL]
- **Confidence:** High/Medium/Low

### Points
- **Value:** XX points
- **Rationale:** [why this point value]

### Localization
- **English:** [action name and description]
- **Spanish:** [action name and description]
- **Japanese:** [action name and description]

### Notes
[Any additional context, assumptions, or considerations]
```

### Template: Learn Only Action

```markdown
## Learn: [Topic Name]

**Category:** learning
**Related SDGs:** [list of SDG numbers]

### Why Learn Only?
[Explain why this doesn't have a direct individual action]

### Ways to Contribute
1. [Indirect action 1]
2. [Indirect action 2]
3. [Resource to learn more]

### Resources
- [Link 1: Description]
- [Link 2: Description]
- [Link 3: Description]

### Localization
- **English:** [title and description]
- **Spanish:** [title and description]
- **Japanese:** [title and description]
```

---

## SDG-Specific Research Notes

### SDG 1: No Poverty
**Type:** Learn + Indirect

**Potential Actions:**
- Donate to poverty relief organizations
- Buy fair trade products
- Volunteer at food banks
- Support living wage initiatives

**Resources to Link:**
- UN Poverty Portal
- Local food bank directories
- Fair trade certification info

---

### SDG 2: Zero Hunger
**Type:** Direct + Indirect

**Potential Actions:**
- Reduce food waste (weigh and track)
- Grow own vegetables
- Buy local produce
- Donate to food banks
- Support sustainable agriculture
- Compost food scraps

**CO₂ Research Focus:**
- Food waste emissions (methane from landfill)
- Food miles (transport emissions)
- Agricultural practices

---

### SDG 3: Good Health and Well-being
**Type:** Direct

**Potential Actions:**
- Walk or bike instead of drive
- Take stairs instead of elevator
- Exercise outdoors (no gym electricity)
- Prepare healthy home-cooked meals
- Mental health breaks in nature

**CO₂ Research Focus:**
- Active transport vs car
- Gym energy consumption
- Food processing emissions

---

### SDG 4: Quality Education
**Type:** Learn + Indirect

**Potential Actions:**
- Donate books or school supplies
- Tutor or mentor students
- Support education nonprofits
- Share educational resources online
- Take free sustainability courses

**Resources to Link:**
- Khan Academy
- Coursera sustainability courses
- Local tutoring programs

---

### SDG 5: Gender Equality
**Type:** Learn + Indirect

**Potential Actions:**
- Support women-owned businesses
- Donate to women's organizations
- Advocate for equal pay
- Mentor women/girls
- Challenge gender stereotypes

**Resources to Link:**
- UN Women
- Local women's organizations
- Women in sustainability leaders

---

### SDG 6: Clean Water and Sanitation
**Type:** Direct

**Potential Actions:**
- Take shorter showers
- Fix water leaks
- Turn off tap while brushing
- Use water-efficient appliances
- Collect rainwater for garden
- Reduce water pollution (eco-friendly products)

**CO₂ Research Focus:**
- Water treatment energy
- Water heating energy
- Pumping/distribution energy

---

### SDG 7: Affordable and Clean Energy
**Type:** Direct

**Potential Actions:**
- Switch to LED bulbs
- Unplug unused devices
- Use natural light
- Air dry clothes
- Adjust thermostat
- Use renewable energy provider
- Install solar panels

**CO₂ Research Focus:**
- Grid electricity emissions by region
- Appliance energy consumption
- Standby power ("vampire" energy)

---

### SDG 8: Decent Work and Economic Growth
**Type:** Learn + Indirect

**Potential Actions:**
- Support ethical businesses
- Buy fair trade products
- Choose sustainable employers
- Advocate for worker rights
- Support small/local businesses

**Resources to Link:**
- B Corp directory
- Fair trade certification
- Ethical consumer guides

---

### SDG 9: Industry, Innovation and Infrastructure
**Type:** Learn + Indirect

**Potential Actions:**
- Repair instead of replace
- Support sustainable startups
- Choose durable products
- Advocate for green infrastructure
- Use shared/public resources

**Resources to Link:**
- Right to repair movement
- Sustainable innovation examples
- Green building standards

---

### SDG 10: Reduced Inequalities
**Type:** Learn + Indirect

**Potential Actions:**
- Support minority-owned businesses
- Donate to equity organizations
- Advocate for inclusive policies
- Educate self on systemic issues
- Volunteer for social justice

**Resources to Link:**
- Equity and inclusion organizations
- Social justice resources
- Community support programs

---

### SDG 11: Sustainable Cities and Communities
**Type:** Direct

**Potential Actions:**
- Use public transportation
- Participate in community gardens
- Support local businesses
- Reduce car trips
- Advocate for bike lanes
- Participate in community cleanup

**CO₂ Research Focus:**
- Public transit vs car emissions
- Urban vs suburban living
- Community resource sharing

---

### SDG 12: Responsible Consumption and Production
**Type:** Direct (Primary Focus)

**Potential Actions:**
- Use reusable bags/cups/containers
- Buy secondhand
- Refuse single-use plastics
- Recycle properly
- Compost
- Buy less, buy better
- Repair items
- Borrow/share tools

**CO₂ Research Focus:**
- Lifecycle analysis of products
- Recycling vs landfill emissions
- Fast fashion impact

---

### SDG 13: Climate Action
**Type:** Direct (Primary Focus)

**Potential Actions:**
- Calculate carbon footprint
- Offset carbon emissions
- Climate advocacy
- Vote for climate policies
- Educate others
- All transport/energy/food actions

**CO₂ Research Focus:**
- Carbon offset verification
- Advocacy impact studies
- Collective action research

---

### SDG 14: Life Below Water
**Type:** Direct

**Potential Actions:**
- Reduce plastic use
- Choose sustainable seafood
- Beach/waterway cleanup
- Avoid products with microbeads
- Support ocean conservation
- Reduce fertilizer runoff

**CO₂ Research Focus:**
- Plastic lifecycle emissions
- Fishing industry emissions
- Ocean acidification

---

### SDG 15: Life on Land
**Type:** Direct

**Potential Actions:**
- Plant native species
- Avoid pesticides
- Support reforestation
- Reduce paper use
- Buy sustainable wood/paper
- Create wildlife habitat
- Compost

**CO₂ Research Focus:**
- Deforestation impact
- Soil carbon sequestration
- Biodiversity and carbon

---

### SDG 16: Peace, Justice and Strong Institutions
**Type:** Learn Only

**Why Learn Only:**
This SDG focuses on governance, institutions, and systemic change that individuals cannot directly impact through daily actions.

**Ways to Contribute:**
- Vote in all elections
- Contact elected representatives
- Participate in peaceful advocacy
- Support transparency organizations
- Stay informed on civic issues

**Resources to Link:**
- Local government contact info
- Civic engagement guides
- Transparency International

---

### SDG 17: Partnerships for the Goals
**Type:** Learn Only

**Why Learn Only:**
This SDG focuses on global partnerships, international cooperation, and systemic collaboration.

**Ways to Contribute:**
- Join sustainability organizations
- Participate in community initiatives
- Support international cooperation
- Share knowledge and resources
- Collaborate on local projects

**Resources to Link:**
- UN SDG partnership platform
- Local sustainability groups
- Global collaboration initiatives

---

## Progress Tracking

### Research Status by SDG

| SDG | Status | Actions Defined | Notes |
|-----|--------|-----------------|-------|
| 1 | Not Started | 0 | Learn + Indirect |
| 2 | Partial | 3 | Need more direct actions |
| 3 | Partial | 3 | Need more wellness actions |
| 4 | Not Started | 0 | Learn + Indirect |
| 5 | Not Started | 0 | Learn + Indirect |
| 6 | Partial | 4 | Good coverage |
| 7 | Partial | 4 | Good coverage, expand |
| 8 | Not Started | 0 | Learn + Indirect |
| 9 | Not Started | 0 | Learn + Indirect |
| 10 | Not Started | 0 | Learn + Indirect |
| 11 | Partial | 3 | Need community actions |
| 12 | Partial | 13 | Good coverage, expand |
| 13 | Partial | 17 | Comprehensive, maintain |
| 14 | Partial | 3 | Need ocean actions |
| 15 | Partial | 2 | Need biodiversity actions |
| 16 | Not Started | 0 | Learn Only |
| 17 | Not Started | 0 | Learn Only |

### Research Stages

| Stage | Focus | Target Actions |
|-------|-------|----------------|
| 1 | SDG 12, 13 (expand existing) | +15 |
| 2 | SDG 2, 6, 7 (expand existing) | +15 |
| 3 | SDG 3, 11, 14, 15 | +15 |
| 4 | SDG 1, 4, 5 (learn + indirect) | +10 |
| 5 | SDG 8, 9, 10 (learn + indirect) | +10 |
| 6 | SDG 16, 17 (learn only) + review | +6 |

---

## Quality Checklist

Before adding an action to the library:

- [ ] CO₂ impact researched from Tier 1-2 source
- [ ] Calculation methodology documented
- [ ] Points value follows established formula
- [ ] Action name is clear and actionable
- [ ] Description explains the impact
- [ ] Related SDGs correctly identified
- [ ] Localization complete (EN/ES/JA)
- [ ] Category assigned correctly
- [ ] Icon selected appropriately

---

## Common CO₂ Reference Values

For quick reference during research:

| Activity | CO₂ Impact | Source |
|----------|------------|--------|
| 1 km by car (average) | ~200g | DEFRA |
| 1 km by bus | ~100g | DEFRA |
| 1 km by train | ~40g | DEFRA |
| 1 km by bike/walk | ~0g | - |
| 1 kg beef | ~27,000g | Our World in Data |
| 1 kg chicken | ~6,900g | Our World in Data |
| 1 kg vegetables | ~2,000g | Our World in Data |
| 1 plastic bag | ~33g | EPA |
| 1 aluminum can (recycled) | ~150g saved | EPA |
| 1 plastic bottle (recycled) | ~100g saved | EPA |
| 1 kWh electricity (US avg) | ~400g | EPA |
| 1 kWh electricity (UK avg) | ~230g | DEFRA |
| 1 minute shower (hot) | ~30g | Carbon Trust |
| 1 load laundry (hot) | ~500g | Carbon Trust |
| 1 load laundry (cold) | ~100g | Carbon Trust |

---

## Research Log

### [Date]
**Researcher:** [Name]
**SDGs Covered:** [List]
**Actions Added:** [Count]
**Notes:** [Summary of findings]

---

*This document will be updated as research progresses.*
