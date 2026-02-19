/**
 * Story Metadata:
 * - Route: /
 * - Target File: app/page.tsx
 * - Page Action: modify_existing
 *
 * Tests for Epic 1, Story 1: Home Page Setup
 *
 * Verifies that the Dashboard shell replaces the template placeholder on the
 * home page, showing the correct headings and application header text.
 *
 * No API calls are made in this story — static shell content only.
 */
import { vi, describe, it, expect, beforeEach } from 'vitest';
import { render, screen } from '@testing-library/react';
import { axe } from 'vitest-axe';

// Mock next-auth so auth imports do not error in the test environment
vi.mock('next-auth', () => ({
  __esModule: true,
  default: vi.fn(),
}));

vi.mock('@/lib/auth/auth', () => ({
  auth: vi.fn(() => Promise.resolve(null)),
  handlers: { GET: vi.fn(), POST: vi.fn() },
  signIn: vi.fn(),
  signOut: vi.fn(),
}));

// Import the real home page — assertions WILL FAIL until the placeholder is replaced
import HomePage from '@/app/page';

describe('Epic 1 Story 1 — Home Page Setup', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe('Dashboard heading', () => {
    it('displays the "DASHBOARD" heading when the page loads', () => {
      render(<HomePage />);
      expect(
        screen.getByRole('heading', { name: /dashboard/i }),
      ).toBeInTheDocument();
    });

    it('does not show the template placeholder text', () => {
      render(<HomePage />);
      expect(
        screen.queryByText(/replace this with your feature implementation/i),
      ).not.toBeInTheDocument();
    });
  });

  describe('Application header', () => {
    it('shows the application title "BetterBond Commission Payments" in the header', () => {
      render(<HomePage />);
      expect(
        screen.getByText(/betterbond commission payments/i),
      ).toBeInTheDocument();
    });
  });

  describe('Agency Summary section', () => {
    it('displays the "AGENCY SUMMARY" section heading', () => {
      render(<HomePage />);
      expect(screen.getByText(/agency summary/i)).toBeInTheDocument();
    });
  });

  describe('Accessibility', () => {
    it('has no accessibility violations', async () => {
      const { container } = render(<HomePage />);
      const results = await axe(container);
      expect(results.violations).toHaveLength(0);
    });
  });
});
